#!/usr/bin/env python3

import argparse
import configparser
from collections.abc import Iterable
from enum import Enum, auto
import hashlib
import inspect
import logging
from pathlib import Path
import shlex
import stat
import subprocess
import sys
import termios
import textwrap
import tty
from typing import (
	Any,
	Dict,
	List,
	Optional,
	Tuple,
	Union,
)


def err(*args: Any) -> None:
	""" Print to stderr. """
	print(*args, file = sys.stderr)


def hash_file(path: Path) -> str:
	""" Get a hash of the given path. """
	with path.open('rb') as f:
		return hashlib.sha256(f.read()).hexdigest()


def _read_char() -> str:
	""" Read a single character from stdin. """
	fd = sys.stdin.fileno()
	old_settings = termios.tcgetattr(fd)
	try:
		tty.setraw(fd)
		return sys.stdin.read(1)
	finally:
		termios.tcsetattr(fd, termios.TCSADRAIN, old_settings)


def read_char() -> str:
	""" Read a single character from stdin, and handle special cases with sensible behaviour. """
	c = _read_char()
	if c == '\x03':
		raise KeyboardInterrupt
	elif c == '\x04':
		raise EOFError
	return c


# {{{ Config

class FileAction(Enum):
	""" The actions that can be taken for a given source file. """
	LINK = 'link'
	SKIP = 'skip'
	RECURSE = 'recurse'


class FileConfig(object):
	""" The configuration for a given source file. """
	def __init__(self, path: Path, parent: Optional['FileConfig']):
		self.path = path
		self.from_config = False
		self.processed = False
		self.targets: List[Path]
		if parent:
			self.targets = [parent / path.name for parent in parent.targets]
		else:
			self.targets = [Path(f'.{path}')]

		# Skip hidden files by default
		self.action: FileAction
		if path.name.startswith('.'):
			self.action = FileAction.SKIP
		else:
			self.action = FileAction.LINK

	def load_from_config(self, items: List[Tuple[str, str]]) -> None:
		""" Create a FileConfig instance from a config section. """
		data = dict(items)

		# Mark as being explicitly defined
		self.from_config = True

		if 'action' in data:
			try:
				self.action = FileAction(data.pop('action'))
			except ValueError as e:
				raise ValueError(f'Invalid action set for {self.path}')

		if 'target' in data:
			if self.action == FileAction.SKIP:
				raise KeyError(f'A target was set for {self.path}, but the action is {self.action}')
			self.targets = [Path(t.strip()) for t in data.pop('target').split(',') if t.strip()]
			if not self.targets:
				raise ValueError(f'Invalid target set for {self.path}')

		if data:
			raise ValueError(f'Unexpected properties for {self.path}: {", ".join(data.keys())}')


class Config(configparser.ConfigParser):
	"""
	A wrapper around ConfigParser that allows getting a configuration for any path, regardless of whether it appears in
	the config file.
	"""
	def __init__(self, root_path: Path, config_path: Path, *args: Any, **kwargs: Any):
		super().__init__(*args, **kwargs)
		self._path_info: Dict[Path, FileConfig] = {}
		self._root_path = root_path
		with config_path.open('r') as f:
			self.read_file(f)
		self._path_info[Path('.')] = self.get_info(self._root_path)

	def get_info(self, path: Path) -> FileConfig:
		# Paths in the config are always relative to the root folder of the repository
		path = (self._root_path / path).relative_to(self._root_path)

		# Re-use a previously made config object if available
		if path in self._path_info:
			return self._path_info[path]

		# Get the parent config, if any
		parent: Optional[FileConfig] = None
		if path.parent != Path('.'):
			parent = self.get_info(path.parent)

		# Create a new config
		config = FileConfig(path, parent)

		# If there is a section for this path, load the config from it
		if self.has_section(path.as_posix()):
			config.load_from_config(self.items(path.as_posix()))

		# Store for later use
		self._path_info[path] = config

		return config

# }}}


# {{{ Virtual FS

class VirtualFSError(Exception):
	""" Error class for fake filesystem errors. """

class VirtualFileExistsError(VirtualFSError, FileExistsError):
	pass

class VirtualFileNotFoundError(VirtualFSError, FileNotFoundError):
	pass

class VirtualNotADirectoryError(VirtualFSError, NotADirectoryError):
	pass

class VirtualPermissionError(VirtualFSError, PermissionError):
	pass


class VirtualFileType(Enum):
	""" The types of files that can virtually exist. """
	FILE = auto()
	DIRECTORY = auto()
	SYMLINK = auto()
	NONE = auto() # No such file/directory exists
	OTHER = auto()


class VirtualFileInfo(object):
	""" Information about a virtual filesystem object. """
	def __init__(
		self,
		fs: 'VirtualFS',
		path: Path,
		type_: VirtualFileType,
		is_from_fs: bool,
		*,
		inode: Optional[int] = None,
		links_to: Optional[Path] = None,
	):
		self.fs = fs
		self.path = Path(path)
		self.type = type_
		self.is_from_fs = is_from_fs
		self.inode = inode
		self.links_to = (path.parent / links_to) if links_to else None

	@property
	def real(self) -> 'VirtualFileInfo':
		"""
		Follow the symlink to the original source.

		Returns a VirtualFileInfo, with a type that is NOT VirtualFileType.SYMLINK.
		"""
		if self.type != VirtualFileType.SYMLINK:
			return self
		assert self.links_to is not None
		try:
			return self.fs.get(self.links_to).real
		except VirtualFSError:
			return VirtualFileInfo(self.fs, self.links_to, VirtualFileType.NONE, True)

	@property
	def non_virtual_path(self) -> Optional[Path]:
		""" Get the path to the actual location on disk that this corresponds to, or None if this doesn't exist. """
		if self.links_to is None:
			return self.path
		return self.fs.get(self.links_to).non_virtual_path

	def __repr__(self) -> str:
		parts = []
		parts.append(f"type {self.type}")
		parts.append('based on fs' if self.is_from_fs else 'virtual')
		if self.links_to:
			parts.append(f"links to '{self.links_to}'")
		return f"<File info for '{self.path}', {', '.join(parts)}>"


class VirtualFS(object):
	""" A layer that provides information about the filesystem that knows about changes made by previous steps. """
	def __init__(self) -> None:
		self.cache: Dict[Path, VirtualFileInfo] = {}
		self.log = logging.getLogger(self.__class__.__name__)

	def get(self, path: Path, *, parent_none_is_none: bool = False) -> VirtualFileInfo:
		""" Get a VirtualFileInfo describing the given path. """
		if path in self.cache:
			return self.cache[path]

		if path.parent == path:
			return self._cache(path, self._from_fs(path))

		parent = self.get(path.parent, parent_none_is_none = parent_none_is_none)
		rparent = parent.real

		if rparent.type == VirtualFileType.DIRECTORY:
			if rparent.is_from_fs:
				# Get from filesystem.
				return self._cache(path, self._from_fs(path))
			else:
				# The parent is virtual, so there is no reason to check the filesystem.
				return self._cache(path, VirtualFileInfo(self, path, VirtualFileType.NONE, False))
		elif rparent.type == VirtualFileType.NONE and parent_none_is_none:
			return self._cache(path, VirtualFileInfo(self, path, VirtualFileType.NONE, False))
		else:
			raise VirtualNotADirectoryError(f"Parent of '{path}' ('{rparent.path}') is not a directory: {rparent.type}")

	def delete(self, path: Path) -> None:
		""" Marks the given path as deleted. """
		self._log(logging.DEBUG, f'delete {path}')
		self._assert_exists(path)
		entry = self.get(path)
		real = entry.real
		if real.type == VirtualFileType.DIRECTORY:
			for p, e in list(self.cache.items()):
				if real.path in p.parents:
					del self.cache[p]
		self._cache(path, VirtualFileInfo(self, path, VirtualFileType.NONE, False))

	def mkdir(self, path: Path) -> None:
		""" Marks the given path as containing a new directory. """
		self._log(logging.DEBUG, f'mkdir {path}')
		self._assert_not_exists(path)
		self._cache(path, VirtualFileInfo(self, path, VirtualFileType.DIRECTORY, False))

	def link(self, source: Path, target: Path) -> None:
		"""
		Mark the given target path as being a link to the given source.

		Will be a hardlink for a file, and a symlink for anything else.
		"""
		if self.get(source).type == VirtualFileType.FILE:
			self.hardlink(source, target)
		else:
			self.symlink(source, target)

	def symlink(self, source: Path, target: Path) -> None:
		""" Mark the given target path as being a symbolic link to the given source. """
		self._log(logging.DEBUG, f'symlink {source} to {target}')
		self._assert_not_exists(target)
		self._assert_exists(source) # Not required, but helps prevent problems.
		self._cache(target, VirtualFileInfo(self, target, VirtualFileType.SYMLINK, False, links_to = source))

	def hardlink(self, source: Path, target: Path) -> None:
		""" Mark the given target path as being a hardlink to the given source. """
		self._log(logging.DEBUG, f'hardlink {source} to {target}')
		self._assert_not_exists(target)
		self._assert_exists(source)
		source_info = self.get(source)
		if source_info.type != VirtualFileType.FILE:
			raise VirtualPermissionError(f"Operation not permitted: '{source}' -> '{target}'")
		self._cache(target, VirtualFileInfo(
			self,
			target,
			VirtualFileType.FILE,
			False,
			inode = source_info.inode,
			links_to = source,
		))

	def scandir(self, path: Path) -> Iterable[VirtualFileInfo]:
		""" Provide a listing of files in a given directory. """
		entry = self.get(path).real
		self._assert_exists(entry.path)
		if entry.type != VirtualFileType.DIRECTORY:
			raise NotADirectoryError(f"Not a directory: '{path}'")
		if entry.is_from_fs:
			return (self.get(p) for p in entry.path.glob('*'))
		else:
			return (e for (p, e) in self.cache.items() if p.parent == entry.path)

	def _assert_exists(self, path: Path) -> None:
		entry = self.get(path)
		if entry.type == VirtualFileType.NONE:
			raise VirtualFileNotFoundError(f"No such file or directory: '{path}'")

	def _assert_not_exists(self, path: Path) -> None:
		entry = self.get(path)
		if entry.type != VirtualFileType.NONE:
			raise VirtualFileExistsError(f"File exists: '{path}'")

	def _cache(self, path: Path, entry: VirtualFileInfo) -> VirtualFileInfo:
		self.cache[path] = entry
		return entry

	def _from_fs(self, path: Path) -> VirtualFileInfo:
		try:
			linfo = path.lstat()
		except FileNotFoundError:
			return VirtualFileInfo(self, path, VirtualFileType.NONE, True)

		if stat.S_ISLNK(linfo.st_mode):
			return VirtualFileInfo(self, path, VirtualFileType.SYMLINK, True, links_to = path.readlink())

		info = path.stat()

		if stat.S_ISDIR(info.st_mode):
			return VirtualFileInfo(self, path, VirtualFileType.DIRECTORY, True)
		elif stat.S_ISREG(info.st_mode):
			return VirtualFileInfo(self, path, VirtualFileType.FILE, True, inode = linfo.st_ino)
		else:
			return VirtualFileInfo(self, path, VirtualFileType.OTHER, True)

	def _log(self, level: int, message: str) -> None:
		curframe = inspect.currentframe()
		calframe = inspect.getouterframes(curframe, 2)
		caller = calframe[2]
		self.log.log(level, f'{message} - {caller.function}:{caller.lineno}')

# }}}


# {{{ Commands

class Command(object):
	""" A command that has to be executed to get to the desired state. """
	def __init__(self, target: Path):
		self.target = target

	def __str__(self) -> str:
		return f'# {shlex.quote(str(self.target))}'


class LinkCommand(Command):
	""" An ln command that has to be executed to get to the desired state. """
	def __init__(
		self,
		source: Path,
		target: Path,
		flags: str = '',
		/,
		symbolic: bool = False,
		force: bool = False,
		no_target_directory: bool = False,
	):
		super().__init__(target)
		self.source = source.resolve()
		self.symbolic = symbolic
		self.force = force
		self.no_target_directory = no_target_directory

	def __str__(self) -> str:
		flags = ''
		if self.symbolic:
			flags += 's'
		if self.force:
			flags += 'f'
		if self.no_target_directory:
			flags += 'T'
		return f'ln {f"-{flags} " if flags else ""}-- {shlex.quote(str(self.source))} {shlex.quote(str(self.target))}'


class DeleteCommand(Command):
	""" An rm command that has to be executed to get to the desired state. """
	def __str__(self) -> str:
		return f'rm -- {shlex.quote(str(self.target))}'


class MkdirCommand(Command):
	""" An mkdir command that has to be executed to get to the desired state. """
	def __str__(self) -> str:
		return f'mkdir {shlex.quote(str(self.target))}'

# }}}


# {{{ Processor

class Processor(object):
	""" A class to process all source files into a series of command to get into the desired state. """
	def __init__(self, args: 'Args', config: Config):
		self.args = args
		self.config = config
		self.fs = VirtualFS()
		self.commands: List[Command] = []

	def process_dir(self, path: Path, only_explicit: bool = False) -> None:
		for entry in self.fs.scandir(path):
			self.process_entry(entry, only_explicit)

	def process_entry(self, entry: VirtualFileInfo, only_explicit: bool = False) -> None:
		fc = self.config.get_info(entry.path)

		if fc.processed:
			return

		if only_explicit and not fc.from_config:
			return

		if fc.action == FileAction.RECURSE:
			self.apply_recurse(entry, fc)
			fc.processed = True

		elif fc.action == FileAction.SKIP:
			fc.processed = True

		elif fc.action == FileAction.LINK:
			self.apply_link(entry, fc)
			fc.processed = True

		else:
			err(f'No behaviour has been defined for the action for {entry.path}')

	def process_explicit(self) -> None:
		""" Make sure all paths mentioned explicitly in the config have been processed. """
		for pathstr in self.config.sections():
			path = Path(pathstr)
			fc = self.config.get_info(path)
			if not fc.processed:
				parent = self.args.root / path.parent
				try:
					self.process_dir(parent, True)
				except FileNotFoundError:
					err(f'Unable to find parent directory {parent} for {path}')
					raise

	def apply_recurse(self, entry: VirtualFileInfo, fc: FileConfig) -> None:
		if not entry.real.type == VirtualFileType.DIRECTORY:
			err(f'Cannot recurse non-directory {fc.path}')
			return

		# Validate that all targets are actually something we can nest files under
		for targetname in fc.targets[:]:
			target = Path.home() / targetname
			tentry = self.fs.get(target, parent_none_is_none = True)
			needs_mkdir = False
			if tentry.type == VirtualFileType.FILE:
				# The target is a file, but we need it to be a directory
				if self.confirm_overwrite(fc.path, target, True):
					self.fs.delete(target)
					self.commands.append(DeleteCommand(target))
					needs_mkdir = True
				else:
					err(f'Skipping target {target} for {fc.path}, as a file is in the way.')
					fc.targets.remove(targetname)
			elif tentry.type == VirtualFileType.SYMLINK:
				# The target is a symlink, which we can just overwrite.
				self.fs.delete(target)
				self.commands.append(DeleteCommand(target))
				needs_mkdir = True
			elif tentry.type == VirtualFileType.OTHER:
				# The target is something else (eg a socket), so we bail out
				err(f'Skipping target {target} for {fc.path}, as something is in the way.')
				fc.targets.remove(targetname)
			# If we removed whatever was in place of the target, we need to create a directory to take its place
			if needs_mkdir:
				self.fs.mkdir(target)
				self.commands.append(MkdirCommand(target))

		self.process_dir(entry.path)

	def apply_link(self, entry: VirtualFileInfo, fc: FileConfig) -> None:
		symbolic = (entry.real.type == VirtualFileType.DIRECTORY)
		for targetname in fc.targets:
			target = Path.home() / targetname
			if self.should_link_be_created(entry, fc, target):
				tentry = self.fs.get(target, parent_none_is_none = True)
				# If the parent path is missing, create it now.
				if self.fs.get(target.parent, parent_none_is_none = True).type == VirtualFileType.NONE:
					self.mkdirs(target.parent)
				# If the target exists, it has to be force replaced.
				force = (tentry.type != VirtualFileType.NONE)
				if force:
					self.fs.delete(target)
				# If the target is a directory, add a flag to prevent the symlink from being created inside it.
				no_target_directory = (tentry.real.type == VirtualFileType.DIRECTORY)

				self.fs.link(entry.path, target)
				assert entry.non_virtual_path is not None
				self.commands.append(LinkCommand(
					entry.non_virtual_path,
					target,
					symbolic = symbolic,
					force = force,
					no_target_directory = no_target_directory,
				))

	def should_link_be_created(self, entry: VirtualFileInfo, fc: FileConfig, target_path: Path) -> bool:
		target = self.fs.get(target_path, parent_none_is_none = True)

		if self.args.assume_empty:
			return True

		if target.real.type == VirtualFileType.NONE:
			# The target either doesn't exist, or is a broken symlink
			return True

		if entry.real == target.real or entry.real.inode == target.real.inode:
			# The link is already present, so do nothing
			return False

		if target.type == VirtualFileType.SYMLINK:
			# The target is a symlink, but points to a different location. We can just overwrite this
			return True

		if target.type == VirtualFileType.DIRECTORY:
			# The target is a different directory, so we bail out
			err(
					f'Attempted to link {fc.path} to {target}, but a directory exists in this location. '
					'There is no automatic fix for this.'
					)
			return False

		if target.type == VirtualFileType.OTHER:
			# The target is something else (eg a socket), so we bail out
			err(
					f'Attempted to link {fc.path} to {target}, but something in this location. '
					'There is no automatic fix for this.'
					)
			return False

		# The target is a file, so it can be replaced entirely, but not without losing something
		# If the entry is a file with identical contents as the target we can replace it safely
		isdir = entry.real.type == VirtualFileType.DIRECTORY
		if not isdir:
			assert target.non_virtual_path is not None
			assert entry.non_virtual_path is not None
			if hash_file(target.non_virtual_path) == hash_file(entry.non_virtual_path):
				return True

		# Prompt the user for confirmation
		return self.confirm_overwrite(fc.path, target.path, isdir)

	def confirm_overwrite(self, source: Path, target: Path, isdir: bool) -> bool:
		print(
				f'Attempting to link {"directory" if isdir else "file"} {source} to {target}, '
				f'but a file exists in this location.'
				)
		if self.args.overwrite:
			return True
		while True:
			print(f'Do you want to replace it? [yn{"" if isdir else "d"}]')
			c = read_char().lower()
			if c == 'y':
				return True
			elif c == 'n':
				return False
			elif c == 'd' and not isdir:
				print()
				subprocess.run(['diff', source, target])
				print()

	def mkdirs(self, path: Path) -> None:
		pinfo = self.fs.get(path.parent, parent_none_is_none = True)
		if pinfo.type == VirtualFileType.NONE:
			self.mkdirs(path.parent)
		self.fs.mkdir(path)
		self.commands.append(MkdirCommand(path))

# }}}


class Args(argparse.Namespace):
	assume_empty: bool
	overwrite: bool
	root: Path
	config: Path
	debug: bool


def parse_args() -> Args:
	parser = argparse.ArgumentParser(description = (
		'Generate a list of commands that setup the home directory to use the files in this repository.'
		))
	parser.add_argument(
			'--assume-empty',
			action = 'store_true',
			help = (
				'Pretend the home directory is empty. '
				'Really only useful for testing, as the generated commands are likely to cause issues.'
				),
			)
	parser.add_argument(
			'-y', '--yes',
		action = 'store_true',
		dest = 'overwrite',
		help = 'Assume yes to all overwrite prompts.',
	)
	root = Path(__file__).parent.parent.resolve()
	parser.add_argument('-r', '--root', default = root, help = f'Path to the root folder.')
	parser.add_argument('-c', '--config', default = (root / 'scripts' / 'config'), help = 'Path to the config.')
	parser.add_argument('--debug', action = 'store_true', help = 'Output more logging information.')
	return parser.parse_args(namespace = Args())


def main(args: Args) -> None:
	# Read the config
	config = Config(args.root, args.config)

	# Read all the available config items, to detect errors
	for path in config.sections():
		config.get_info(Path(path))

	# Process the files in the root directory
	processor = Processor(args, config)
	processor.process_dir(args.root)
	processor.process_explicit()
	processor.process_entry(processor.fs.get(args.root), only_explicit = True)

	# Make sure no items marked in the config have been missed (unless they are to be skipped anyway)
	for path in config.sections():
		fc = config.get_info(Path(path))
		if fc.action != FileAction.SKIP and not fc.processed:
			print(f'{path} is in the config, but has not been processed')

	# If there is nothing to be done, remove old command files and exit
	cmdpath = args.root / 'cmds'
	if not processor.commands:
		print('Everything seems to be in order')
		if cmdpath.exists():
			cmdpath.unlink()
		return

	# Write the commands to a file that can be sourced by the user
	commands = [str(cmd) for cmd in processor.commands]
	indented_commands = '\n\t\t\t\t'.join(commands)
	with cmdpath.open('w') as f:
		f.write(textwrap.dedent(f'''
			#!/usr/bin/env sh
			(
				set -e

				{indented_commands}

				rm {shlex.quote(str(cmdpath))}
			)
		''').strip())
	print('Please confirm the following commands are correct (directories will be created as needed):')
	print()
	print('\n'.join(commands))
	print()
	print(f'To execute these commands type "sh {cmdpath}".')


def setup_logging() -> None:
	formatter = logging.Formatter('%(asctime)s - %(name)s - %(levelname)s - %(message)s')

	handler = logging.StreamHandler(sys.stdout)
	handler.setLevel(logging.DEBUG)
	handler.setFormatter(formatter)

	root = logging.getLogger(None)
	root.setLevel(logging.DEBUG)
	root.addHandler(handler)


if __name__ == '__main__':
	args = parse_args()
	if args.debug:
		setup_logging()
	main(args)
