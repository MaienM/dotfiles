#!/usr/bin/env python3

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
import tty


ROOT = os.path.realpath(os.path.join(os.path.dirname(__file__), '..'))
CONFIG = os.path.join(ROOT, 'scripts', 'config')


def err(*args):
	""" Print to stderr. """
	print(*args, fd = sys.stderr)


def hash_file(path):
	""" Get a hash of the given path. """
	with open(path, 'rb') as f:
		return hashlib.sha256(f.read()).hexdigest()


def read_char():
	""" Read a single character from stdin. """
	fd = sys.stdin.fileno()
	old_settings = termios.tcgetattr(fd)
	try:
		tty.setraw(fd)
		return sys.stdin.read(1)
	finally:
		termios.tcsetattr(fd, termios.TCSADRAIN, old_settings)


class FileAction(Enum):
	""" The actions that can be taken for a given source file. """
	LINK = 'link'
	SKIP = 'skip'
	RECURSE = 'recurse'


class FileConfig(object):
	""" The configuration for a given source file. """
	def __init__(self, path):
		self.path = path
		self.from_config = False
		self.processed = False
		self.targets = [f'.{path}']

		# Skip hidden files by default
		if os.path.basename(path)[0] == '.':
			self.action = FileAction.SKIP
		else:
			self.action = FileAction.LINK

	def load_from_config(self, items):
		""" Create a FileConfig instance from a config section. """
		data = dict(items)

		# Mark as being explicitly defined
		self.from_config = True

		# Read and validate the action defined for the path
		if 'action' in data:
			try:
				self.action = FileAction(data['action'])
			except ValueError as e:
				raise ValueError(f'Invalid action set for {path}')

		# Read and validate the target(s) set for the path
		if 'target' in data:
			if self.action != FileAction.LINK:
				raise KeyError(f'A target was set for {path}, but the action is {self.action}')
			self.targets = [t.strip() for t in data['target'].split(',')]
			if not self.targets:
				raise ValueError(f'Invalid target set for {path}')


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

		# Create a new config
		config = FileConfig(path)

		# If there is a section for this path, load the config from it
		if self.has_section(path):
			config.load_from_config(self.items(path))

		# Store for later use
		self.path_info[path] = config

		return config


class Processor(object):
	""" A class to process all source files into a series of command to get into the desired state. """
	def __init__(self, config):
		self.config = config
		self.commands = []

	def process_dir(self, path, only_explicit = False):
		for entry in os.scandir(path):
			fc = self.config.get_info(entry.path)

			if fc.action == FileAction.RECURSE:
				self.apply_recurse(entry, fc)
				fc.processed = True
			elif entry.is_dir():
				# Always recurse into directories, so that items inside that are explicitly marked in the config can still
				# be processed
				self.process_dir(entry.path, only_explicit = True)

			if only_explicit and not fc.from_config:
				# While recursing inside non-recurse directories, ignore any items that are not explicitly defined in the
				# config
				continue

			if fc.action == FileAction.SKIP:
				fc.processed = True

			if fc.action == FileAction.LINK:
				self.apply_link(entry, fc)
				fc.processed = True

			if not fc.processed:
				err(f'No behaviour has been defined for the action for {path}')

	def apply_recurse(self, entry, fc):
		if not entry.is_dir():
			err(f'Cannot recurse non-directory {fc.path}')
			return

		self.process_dir(entry.path)

	def apply_link(self, entry, fc):
		flags = ''
		if entry.is_dir():
			flags += 's'

		for target in fc.targets:
			target = os.path.join(os.path.expanduser("~"), target)
			tflags = flags
			if self.should_link_be_created(entry, fc, target):
				# If the target lexists, it has to be force replaced
				if os.path.lexists(target):
					tflags += 'f'
				tflags = f'-{tflags} ' if tflags else ''
				self.commands.append(f'ln {tflags}-- {shlex.quote(entry.path)} {shlex.quote(target)}')

	def should_link_be_created(self, entry, fc, target):
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
			if c == '\x03':
				raise KeyboardInterrupt
			elif c == '\x04':
				raise EOFError
			elif c == 'y':
				return True
			elif c == 'n':
				return False
			elif c == 'd' and not isdir:
				print()
				subprocess.run(['diff', entry.path, target])
				print()


def main():
	# Read the config
	config = Config()
	with open(CONFIG, 'r') as f:
		config.read_file(f)

	# Read all the available config items, to detect errors
	for path in config.sections():
		config.get_info(path)

	# Process the files in the root directory
	processor = Processor(config)
	processor.process_dir(ROOT)

	# Make sure no items marked in the config have been missed (unless they are to be skipped anyway)
	for path in config.sections():
		fc = config.get_info(path)
		if fc.action != FileAction.SKIP and not fc.processed:
			print(f'{path} is in the config, but has not been processed')

	# Write the commands to a file that can be sourced by the user
	cmdpath = os.path.join(ROOT, 'cmds')
	commands = '\n'.join(processor.commands)
	with open(cmdpath, 'w') as f:
		f.write(commands)
		f.write(f'\n\nrm {shlex.quote(cmdpath)}')
	print('Please confirm the following commands are correct:')
	print()
	print(commands)
	print()
	print(f'To execute these commands type "source {cmdpath}".')


if __name__ == '__main__':
	main()
