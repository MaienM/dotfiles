#!/usr/bin/env python3

import argparse
import configparser
from enum import Enum
import hashlib
import os
import os.path
import shlex
import stat
import subprocess
import sys
import termios
import textwrap
import tty


ROOT = os.path.realpath(os.path.join(os.path.dirname(__file__), '..'))
CONFIG = os.path.join(ROOT, 'scripts', 'config')


def err(*args):
	""" Print to stderr. """
	print(*args, file = sys.stderr)


def hash_file(path):
	""" Get a hash of the given path. """
	with open(path, 'rb') as f:
		return hashlib.sha256(f.read()).hexdigest()


def _read_char():
	""" Read a single character from stdin. """
	fd = sys.stdin.fileno()
	old_settings = termios.tcgetattr(fd)
	try:
		tty.setraw(fd)
		return sys.stdin.read(1)
	finally:
		termios.tcsetattr(fd, termios.TCSADRAIN, old_settings)


def read_char():
	""" Read a single character from stdin, and handle special cases with sensible behaviour. """
	c = _read_char()
	if c == '\x03':
		raise KeyboardInterrupt
	elif c == '\x04':
		raise EOFError
	return c


class FileAction(Enum):
	""" The actions that can be taken for a given source file. """
	LINK = 'link'
	SKIP = 'skip'
	RECURSE = 'recurse'


class FileConfig(object):
	""" The configuration for a given source file. """
	def __init__(self, path, parent):
		self.path = path
		self.from_config = False
		self.processed = False
		if parent:
			fname = os.path.basename(path)
			self.targets = [os.path.join(ppath, fname) for ppath in parent.targets]
		else:
			self.targets = [f'.{path}']

		# Skip hidden files by default
		if os.path.basename(path)[0] == '.':
			self.action = FileAction.SKIP
		else:
			self.action = FileAction.LINK

	def load_from_config(self, items):
		""" Create a FileConfig instance from a config section. """
		data = dict(items)
		del data['default']

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
			self.targets = [t.strip() for t in data.pop('target').split(',')]
			if not self.targets:
				raise ValueError(f'Invalid target set for {self.path}')

		if data:
			raise ValueError(f'Unexpected properties for {self.path}: {", ".join(data.keys())}')


class Config(configparser.ConfigParser):
	"""
	A wrapper around ConfigParser that allows getting a configuration for any path, regardless of whether it appears in
	the config file.
	"""
	def __init__(self, *args, **kwargs):
		super(Config, self).__init__(self, *args, **kwargs)
		self.path_info = {}

	def get_info(self, path):
		# Paths in the config are always relative to the root folder of the repository
		path = os.path.relpath(path, ROOT)

		# Re-use a previously made config object if available
		if path in self.path_info:
			return self.path_info[path]

		# Get the parent config, if any
		parent_path = os.path.dirname(path)
		parent = None
		if parent_path:
			parent = self.get_info(parent_path)

		# Create a new config
		config = FileConfig(path, parent)

		# If there is a section for this path, load the config from it
		if self.has_section(path):
			config.load_from_config(self.items(path))

		# Store for later use
		self.path_info[path] = config

		return config


class LinkCommand(object):
	""" A ln command that has to be executed to get to the desired state. """
	def __init__(self, source, target, flags = ''):
		self.source = source
		self.target = target
		self.flags = flags

	def __str__(self):
		flags = f'-{self.flags} ' if self.flags else ''
		return f'ln {flags}-- {shlex.quote(self.source)} {shlex.quote(self.target)}'


class Processor(object):
	""" A class to process all source files into a series of command to get into the desired state. """
	def __init__(self, args, config):
		self.args = args
		self.config = config
		self.commands = []

	def process_dir(self, path, only_explicit = False):
		for entry in os.scandir(path):
			fc = self.config.get_info(entry.path)

			if only_explicit and not fc.from_config:
				continue

			if fc.action == FileAction.RECURSE:
				self.apply_recurse(entry, fc)
				fc.processed = True

			elif fc.action == FileAction.SKIP:
				fc.processed = True

			elif fc.action == FileAction.LINK:
				self.apply_link(entry, fc)
				fc.processed = True

			else:
				err(f'No behaviour has been defined for the action for {path}')

	def process_explicit(self):
		""" Make sure all paths mentioned explicitly in the config have been processed. """
		for path in self.config.sections():
			fc = self.config.get_info(path)
			if not fc.processed:
				dirpath = os.path.abspath(os.path.dirname(path))
				try:
					self.process_dir(dirpath, True)
				except FileNotFoundError:
					err(f'Unable to find parent directory {dirpath} for {path}')

	def apply_recurse(self, entry, fc):
		if not entry.is_dir():
			err(f'Cannot recurse non-directory {fc.path}')
			return

		self.process_dir(entry.path)

	def apply_link(self, entry, fc):
		flags = ''
		if entry.is_dir():
			flags += 's'

		applied_links = False
		for target in fc.targets:
			target = os.path.join(os.path.expanduser("~"), target)
			tflags = flags
			if self.should_link_be_created(entry, fc, target):
				if not applied_links:
					applied_links = True

				# If the target lexists, it has to be force replaced
				if os.path.lexists(target):
					tflags += 'f'

				self.commands.append(LinkCommand(entry.path, target, tflags))

	def should_link_be_created(self, entry, fc, target):
		if self.args.assume_empty:
			return True

		if not os.path.exists(target):
			# The target either doesn't exist, or is a broken symlink
			return True

		try:
			targetinfo = os.stat(target)
		except OSError as e:
			err(f'Encountered error while inspecting {target}: {e.message}')
			return False

		if os.path.samestat(entry.stat(), targetinfo):
			# The link is already present, so do nothing
			return False

		if stat.S_ISDIR(targetinfo.st_mode):
			# The target is a different directory, so we bail out
			err(
				f'Attempted to link {fc.path} to {target}, but a directory exists in this location. '
				'There is no automatic fix for this.'
			)
			return False
		# The target is a file, so it can be replaced entirely, but not without losing something
		# If the entry is a file with identical contents as the target we can replace it safely
		isdir = entry.is_dir()
		if not isdir:
			if hash_file(target) == hash_file(entry.path):
				return True

		# Prompt the user for confirmation
		print(
			f'Attempting to link {"directory" if isdir else "file"} {fc.path} to {target}, '
			f'but a file exists in this location.'
		)
		while True:
			print(f'Do you want to replace it? [yn{"" if isdir else "d"}]')
			c = read_char().lower()
			if c == 'y':
				return True
			elif c == 'n':
				return False
			elif c == 'd' and not isdir:
				print()
				subprocess.run(['diff', entry.path, target])
				print()


def parse_args(args):
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
	return parser.parse_args(args)


def main(args):
	# Read the config
	config = Config()
	with open(CONFIG, 'r') as f:
		config.read_file(f)

	# Read all the available config items, to detect errors
	for path in config.sections():
		config.get_info(path)

	# Process the files in the root directory
	processor = Processor(args, config)
	processor.process_dir(ROOT)
	processor.process_explicit()
	commands = processor.commands[:]

	# Sort the link commands by target, to prevent ordering issues like the following:
	# ln bar ~/.foo/bar
	# ln foo ~/.foo
	# This would cause the folder ~/.foo to be created, causing foo to end up in ~/.foo/foo instead.
	commands.sort(key = lambda cmd: cmd.target)

	# Make sure no items marked in the config have been missed (unless they are to be skipped anyway)
	for path in config.sections():
		fc = config.get_info(path)
		if fc.action != FileAction.SKIP and not fc.processed:
			print(f'{path} is in the config, but has not been processed')

	# If there is nothing to be done, remove old command files and exit
	cmdpath = os.path.join(ROOT, 'cmds')
	if not processor.commands:
		print('Everything seems to be in order')
		if os.path.exists(cmdpath):
			os.path.remove(cmdpath)
		return

	# Write the commands to a file that can be sourced by the user
	commands = [str(cmd) for cmd in commands]
	indented_commands = '\n\t\t\t\t'.join(commands)
	with open(cmdpath, 'w') as f:
		f.write(textwrap.dedent(f'''
			#!/usr/bin/env sh
			(
				set -e

				ln() {{
					[ "$1" == "--" ] && target="$3" || target="$4"
					tdir="$(dirname "$target")"
					[ -d "$tdir" ] || mkdir -p "$tdir"
					command ln "$@"
				}}

				{indented_commands}

				rm {shlex.quote(cmdpath)}
			)
		'''))
	print('Please confirm the following commands are correct (directories will be created as needed):')
	print()
	print('\n'.join(commands))
	print()
	print(f'To execute these commands type "sh {cmdpath}".')


if __name__ == '__main__':
	args = parse_args(sys.argv[1:])
	main(args)
