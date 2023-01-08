#!/usr/bin/env cached-nix-shell
#!nix-shell -i python
#!nix-shell -p python310Packages.pytest

from typing import (
	Generator,
	NamedTuple,
	Set,
)
from pathlib import Path
from os import mkfifo

import pytest

from link import *


def p(path: Path) -> AbsoluteVirtualPath:
	return AbsoluteVirtualPath(path)


class MockStructure(NamedTuple):
	path: Path
	expected_paths: Set[Path]


@pytest.fixture
def mock_structure(tmp_path: Path) -> Generator[MockStructure, None, None]:
	dirs = [
		tmp_path / "dir1",
		tmp_path / "dir1" / "dir11",
		tmp_path / "dir2",
	]
	files = [
		tmp_path / "fileA",
		tmp_path / "fileB",
		tmp_path / "dir1" / "file1A",
		tmp_path / "dir1" / "file1B",
		tmp_path / "dir1" / "dir11" / "file11A",
		tmp_path / "dir2" / "file2A",
	]
	hardlinks = [
		(tmp_path / "hardB", tmp_path / "fileB"),
		(tmp_path / "hard1B", tmp_path / "dir1" / "file1B"),
		(tmp_path / "dir1" / "hardB", tmp_path / "fileB"),
	]
	symlinks = [
		(tmp_path / "symA", tmp_path / "fileA"),
		(tmp_path / "sym1A", tmp_path / "dir1" / "file1A"),
		(tmp_path / "sym11", tmp_path / "dir1" / "dir11"),
		(tmp_path / "dir1" / "symA", tmp_path / "fileA"),
		(tmp_path / "dir1" / "sym2", tmp_path / "dir2"),
		(tmp_path / "symsymA", tmp_path / "symA"),
	]

	for dir in dirs:
		dir.mkdir()
	for file in files:
		file.touch()
	for target, source in hardlinks:
		source.link_to(target)	# Becomes target.hardlink_to(source) in 3.10
	for target, source in symlinks:
		target.symlink_to(source)

	expected_paths = set(tmp_path.glob("**/*"))
	yield MockStructure(tmp_path, expected_paths)

	expected_subpaths = set(path.relative_to(tmp_path) for path in expected_paths)
	actual_subpaths = set(path.relative_to(tmp_path) for path in tmp_path.glob("**/*"))
	assert actual_subpaths == expected_subpaths


class TestVirtualFSGet(object):
	@staticmethod
	@pytest.fixture
	def vfs() -> VirtualFS:
		return VirtualFS()

	class TestGet(object):
		def test_dir(self, vfs: VirtualFS, mock_structure: MockStructure) -> None:
			entry = vfs.get(p(mock_structure.path / "dir1"))

			assert entry.path == mock_structure.path / "dir1"
			assert entry.type == VirtualFileType.DIRECTORY
			assert entry.is_from_fs
			assert entry.links_to is None
			assert entry.real is entry

		def test_file(self, vfs: VirtualFS, mock_structure: MockStructure) -> None:
			entry = vfs.get(p(mock_structure.path / "fileA"))

			assert entry.path == mock_structure.path / "fileA"
			assert entry.type == VirtualFileType.FILE
			assert entry.is_from_fs
			assert entry.links_to is None
			assert entry.real is entry

		def test_missing(self, vfs: VirtualFS, mock_structure: MockStructure) -> None:
			entry = vfs.get(p(mock_structure.path / "fileC"))

			assert entry.path == mock_structure.path / "fileC"
			assert entry.type == VirtualFileType.NONE
			assert entry.is_from_fs
			assert entry.links_to is None
			assert entry.real is entry

		def test_fifo(self, vfs: VirtualFS, mock_structure: MockStructure) -> None:
			path = mock_structure.path / "fifoA"
			mkfifo(path)
			mock_structure.expected_paths.add(path)

			entry = vfs.get(p(path))

			assert entry.path == path
			assert entry.type == VirtualFileType.OTHER
			assert entry.is_from_fs
			assert entry.links_to is None
			assert entry.real is entry

		def test_symlink(self, vfs: VirtualFS, mock_structure: MockStructure) -> None:
			entry = vfs.get(p(mock_structure.path / "symA"))

			assert entry.path == mock_structure.path / "symA"
			assert entry.type == VirtualFileType.SYMLINK
			assert entry.is_from_fs
			assert entry.links_to == mock_structure.path / "fileA"

			real = entry.real
			assert real is not entry
			assert real.path == mock_structure.path / "fileA"
			assert real.type == VirtualFileType.FILE
			assert real.is_from_fs
			assert real.links_to is None

		def test_double_symlink(
			self, vfs: VirtualFS, mock_structure: MockStructure
		) -> None:
			entry = vfs.get(p(mock_structure.path / "symsymA"))

			assert entry.path == mock_structure.path / "symsymA"
			assert entry.type == VirtualFileType.SYMLINK
			assert entry.is_from_fs
			assert entry.links_to == mock_structure.path / "symA"

			real = entry.real
			assert real is not entry
			assert real.path == mock_structure.path / "fileA"
			assert real.type == VirtualFileType.FILE
			assert real.is_from_fs
			assert real.links_to is None

		def test_hardlink(self, vfs: VirtualFS, mock_structure: MockStructure) -> None:
			entry = vfs.get(p(mock_structure.path / "hardB"))

			assert entry.path == mock_structure.path / "hardB"
			assert entry.type == VirtualFileType.FILE
			assert entry.is_from_fs
			assert entry.links_to is None
			assert entry.real is entry
			assert entry.inode == (mock_structure.path / "fileB").stat().st_ino

		def test_nested_file(
			self, vfs: VirtualFS, mock_structure: MockStructure
		) -> None:
			entry = vfs.get(p(mock_structure.path / "dir1" / "file1A"))

			assert entry.path == mock_structure.path / "dir1" / "file1A"
			assert entry.type == VirtualFileType.FILE
			assert entry.is_from_fs
			assert entry.links_to is None
			assert entry.real is entry

		def test_nested_symlink(
			self, vfs: VirtualFS, mock_structure: MockStructure
		) -> None:
			entry = vfs.get(p(mock_structure.path / "dir1" / "symA"))

			assert entry.path == mock_structure.path / "dir1" / "symA"
			assert entry.type == VirtualFileType.SYMLINK
			assert entry.is_from_fs
			assert entry.links_to == mock_structure.path / "fileA"

			real = entry.real
			assert real is not entry
			assert real.path == mock_structure.path / "fileA"
			assert real.type == VirtualFileType.FILE
			assert real.is_from_fs
			assert real.links_to is None

		def test_nested_missing(
			self, vfs: VirtualFS, mock_structure: MockStructure
		) -> None:
			with pytest.raises(NotADirectoryError):
				vfs.get(p(mock_structure.path / "dir3" / "file3A"))

		def test_nested_missing_allowed(
			self, vfs: VirtualFS, mock_structure: MockStructure
		) -> None:
			entry = vfs.get(
				p(mock_structure.path / "dir3" / "file3A"), parent_none_is_none=True
			)

			assert entry.path == mock_structure.path / "dir3" / "file3A"
			assert entry.type == VirtualFileType.NONE
			assert entry.is_from_fs
			assert entry.links_to is None

		def test_parent_file(
			self, vfs: VirtualFS, mock_structure: MockStructure
		) -> None:
			with pytest.raises(NotADirectoryError):
				vfs.get(p(mock_structure.path / "fileA" / "fileAA"))
			with pytest.raises(NotADirectoryError):
				vfs.get(
					p(mock_structure.path / "fileA" / "fileAA"),
					parent_none_is_none=True,
				)

		def test_broken_symlink(
			self, vfs: VirtualFS, mock_structure: MockStructure
		) -> None:
			path = mock_structure.path / "broken"
			path.symlink_to(mock_structure.path / "does_not_exist")
			mock_structure.expected_paths.add(path)

			entry = vfs.get(p(path))

			assert entry.path == path
			assert entry.type == VirtualFileType.SYMLINK
			assert entry.is_from_fs
			assert entry.links_to == mock_structure.path / "does_not_exist"

			real = entry.real
			assert real is not entry
			assert real.path == mock_structure.path / "does_not_exist"
			assert real.type == VirtualFileType.NONE
			assert real.is_from_fs
			assert real.links_to is None

		def test_broken_symlink_nested(
			self, vfs: VirtualFS, mock_structure: MockStructure
		) -> None:
			path = mock_structure.path / "broken"
			path.symlink_to(mock_structure.path / "does" / "not" / "exist")
			mock_structure.expected_paths.add(path)

			entry = vfs.get(p(path))

			assert entry.path == path
			assert entry.type == VirtualFileType.SYMLINK
			assert entry.is_from_fs
			assert entry.links_to == mock_structure.path / "does" / "not" / "exist"

			real = entry.real
			assert real is not entry
			assert real.path == mock_structure.path / "does" / "not" / "exist"
			assert real.type == VirtualFileType.NONE
			assert real.is_from_fs
			assert real.links_to is None

	class TestDelete(object):
		def test_file(self, vfs: VirtualFS, mock_structure: MockStructure) -> None:
			vfs.delete(p(mock_structure.path / "fileA"))
			entry = vfs.get(p(mock_structure.path / "fileA"))

			assert entry.path == mock_structure.path / "fileA"
			assert entry.type == VirtualFileType.NONE
			assert not entry.is_from_fs
			assert entry.links_to is None
			assert entry.real is entry

		def test_dir(self, vfs: VirtualFS, mock_structure: MockStructure) -> None:
			vfs.delete(p(mock_structure.path / "dir1"))
			entry = vfs.get(p(mock_structure.path / "dir1"))

			assert entry.path == mock_structure.path / "dir1"
			assert entry.type == VirtualFileType.NONE
			assert not entry.is_from_fs
			assert entry.links_to is None
			assert entry.real is entry

		def test_nested(self, vfs: VirtualFS, mock_structure: MockStructure) -> None:
			vfs.delete(p(mock_structure.path / "dir1"))
			with pytest.raises(NotADirectoryError):
				vfs.get(p(mock_structure.path / "dir1" / "file1A"))

		def test_lose_nested_changes(
			self, vfs: VirtualFS, mock_structure: MockStructure
		) -> None:
			vfs.mkdir(p(mock_structure.path / "dir2" / "dir21"))
			vfs.delete(p(mock_structure.path / "dir2"))
			with pytest.raises(NotADirectoryError):
				vfs.get(p(mock_structure.path / "dir2" / "dir21"))

		def test_missing(self, vfs: VirtualFS, mock_structure: MockStructure) -> None:
			with pytest.raises(FileNotFoundError):
				vfs.delete(p(mock_structure.path / "fileC"))

	class TestMkdir(object):
		def test_dir(self, vfs: VirtualFS, mock_structure: MockStructure) -> None:
			vfs.mkdir(p(mock_structure.path / "dir3"))
			entry = vfs.get(p(mock_structure.path / "dir3"))

			assert entry.path == mock_structure.path / "dir3"
			assert entry.type == VirtualFileType.DIRECTORY
			assert not entry.is_from_fs
			assert entry.links_to is None
			assert entry.real is entry

		def test_nested_file(
			self, vfs: VirtualFS, mock_structure: MockStructure
		) -> None:
			vfs.mkdir(p(mock_structure.path / "dir3"))
			entry = vfs.get(p(mock_structure.path / "dir3" / "file3A"))

			assert entry.path == mock_structure.path / "dir3" / "file3A"
			assert entry.type == VirtualFileType.NONE
			assert not entry.is_from_fs
			assert entry.links_to is None
			assert entry.real is entry

		def test_parent_file(
			self, vfs: VirtualFS, mock_structure: MockStructure
		) -> None:
			with pytest.raises(NotADirectoryError):
				vfs.mkdir(p(mock_structure.path / "fileA" / "dirA1"))

		def test_parent_missing(
			self, vfs: VirtualFS, mock_structure: MockStructure
		) -> None:
			with pytest.raises(NotADirectoryError):
				vfs.mkdir(p(mock_structure.path / "dir3" / "dir31"))

	class TestLink(object):
		def test_file(self, vfs: VirtualFS, mock_structure: MockStructure) -> None:
			vfs.link(p(mock_structure.path / "fileB"), p(mock_structure.path / "symB"))
			entry = vfs.get(p(mock_structure.path / "symB"))

			assert entry.path == mock_structure.path / "symB"
			assert entry.type == VirtualFileType.FILE

		def test_dir(self, vfs: VirtualFS, mock_structure: MockStructure) -> None:
			vfs.link(p(mock_structure.path / "dir2"), p(mock_structure.path / "sym2"))
			entry = vfs.get(p(mock_structure.path / "sym2"))

			assert entry.path == mock_structure.path / "sym2"
			assert entry.type == VirtualFileType.SYMLINK

		def test_link(self, vfs: VirtualFS, mock_structure: MockStructure) -> None:
			vfs.link(
				p(mock_structure.path / "sym1A"), p(mock_structure.path / "symsym1A")
			)
			entry = vfs.get(p(mock_structure.path / "symsym1A"))

			assert entry.path == mock_structure.path / "symsym1A"
			assert entry.type == VirtualFileType.SYMLINK

		def test_virtual(self, vfs: VirtualFS, mock_structure: MockStructure) -> None:
			vfs.mkdir(p(mock_structure.path / "dir3"))
			vfs.link(p(mock_structure.path / "dir3"), p(mock_structure.path / "sym3"))
			entry = vfs.get(p(mock_structure.path / "sym3"))

			assert entry.path == mock_structure.path / "sym3"
			assert entry.type == VirtualFileType.SYMLINK

		def test_missing(self, vfs: VirtualFS, mock_structure: MockStructure) -> None:
			with pytest.raises(FileNotFoundError):
				vfs.link(
					p(mock_structure.path / "dir3"), p(mock_structure.path / "sym3")
				)

		def test_parent_file(
			self, vfs: VirtualFS, mock_structure: MockStructure
		) -> None:
			with pytest.raises(NotADirectoryError):
				vfs.link(
					p(mock_structure.path / "fileA"),
					p(mock_structure.path / "fileA" / "fileAA"),
				)

		def test_parent_missing(
			self, vfs: VirtualFS, mock_structure: MockStructure
		) -> None:
			with pytest.raises(NotADirectoryError):
				vfs.link(
					p(mock_structure.path / "fileA"),
					p(mock_structure.path / "dir3" / "file3A"),
				)

		def test_exists(self, vfs: VirtualFS, mock_structure: MockStructure) -> None:
			with pytest.raises(FileExistsError):
				vfs.link(
					p(mock_structure.path / "fileA"), p(mock_structure.path / "fileB")
				)

	class TestSymlink(object):
		def test_file(self, vfs: VirtualFS, mock_structure: MockStructure) -> None:
			vfs.symlink(
				p(mock_structure.path / "fileB"), p(mock_structure.path / "symB")
			)
			entry = vfs.get(p(mock_structure.path / "symB"))

			assert entry.path == mock_structure.path / "symB"
			assert entry.type == VirtualFileType.SYMLINK
			assert not entry.is_from_fs
			assert entry.links_to == mock_structure.path / "fileB"

			real = entry.real
			assert real is not entry
			assert real.path == mock_structure.path / "fileB"
			assert real.type == VirtualFileType.FILE
			assert real.is_from_fs
			assert real.links_to is None

		def test_dir(self, vfs: VirtualFS, mock_structure: MockStructure) -> None:
			vfs.symlink(
				p(mock_structure.path / "dir2"), p(mock_structure.path / "sym2")
			)
			entry = vfs.get(p(mock_structure.path / "sym2"))

			assert entry.path == mock_structure.path / "sym2"
			assert entry.type == VirtualFileType.SYMLINK
			assert not entry.is_from_fs
			assert entry.links_to == mock_structure.path / "dir2"

			real = entry.real
			assert real is not entry
			assert real.path == mock_structure.path / "dir2"
			assert real.type == VirtualFileType.DIRECTORY
			assert real.is_from_fs
			assert real.links_to is None

		def test_symlink(self, vfs: VirtualFS, mock_structure: MockStructure) -> None:
			vfs.symlink(
				p(mock_structure.path / "sym1A"), p(mock_structure.path / "symsym1A")
			)
			entry = vfs.get(p(mock_structure.path / "symsym1A"))

			assert entry.path == mock_structure.path / "symsym1A"
			assert entry.type == VirtualFileType.SYMLINK
			assert not entry.is_from_fs
			assert entry.links_to == mock_structure.path / "sym1A"

			real = entry.real
			assert real is not entry
			assert real.path == mock_structure.path / "dir1" / "file1A"
			assert real.type == VirtualFileType.FILE
			assert real.is_from_fs
			assert real.links_to is None

		def test_virtual(self, vfs: VirtualFS, mock_structure: MockStructure) -> None:
			vfs.mkdir(p(mock_structure.path / "dir3"))
			vfs.symlink(
				p(mock_structure.path / "dir3"), p(mock_structure.path / "sym3")
			)
			entry = vfs.get(p(mock_structure.path / "sym3"))

			assert entry.path == mock_structure.path / "sym3"
			assert entry.type == VirtualFileType.SYMLINK
			assert not entry.is_from_fs
			assert entry.links_to == mock_structure.path / "dir3"

			real = entry.real
			assert real is not entry
			assert real.path == mock_structure.path / "dir3"
			assert real.type == VirtualFileType.DIRECTORY
			assert not real.is_from_fs
			assert real.links_to is None

		def test_missing(self, vfs: VirtualFS, mock_structure: MockStructure) -> None:
			with pytest.raises(FileNotFoundError):
				vfs.symlink(
					p(mock_structure.path / "dir3"), p(mock_structure.path / "sym3")
				)

		def test_parent_file(
			self, vfs: VirtualFS, mock_structure: MockStructure
		) -> None:
			with pytest.raises(NotADirectoryError):
				vfs.symlink(
					p(mock_structure.path / "dir1"),
					p(mock_structure.path / "fileA" / "dirA1"),
				)

		def test_parent_missing(
			self, vfs: VirtualFS, mock_structure: MockStructure
		) -> None:
			with pytest.raises(NotADirectoryError):
				vfs.symlink(
					p(mock_structure.path / "dir1"),
					p(mock_structure.path / "dir3" / "dir31"),
				)

		def test_exists(self, vfs: VirtualFS, mock_structure: MockStructure) -> None:
			with pytest.raises(FileExistsError):
				vfs.symlink(
					p(mock_structure.path / "dir1"), p(mock_structure.path / "dir2")
				)

	class TestHardlink(object):
		def test_file(self, vfs: VirtualFS, mock_structure: MockStructure) -> None:
			vfs.hardlink(
				p(mock_structure.path / "fileA"), p(mock_structure.path / "hardA")
			)
			entry = vfs.get(p(mock_structure.path / "hardA"))

			assert entry.path == mock_structure.path / "hardA"
			assert entry.type == VirtualFileType.FILE
			assert not entry.is_from_fs
			assert entry.links_to is None
			assert entry.inode == (mock_structure.path / "fileA").stat().st_ino

		def test_dir(self, vfs: VirtualFS, mock_structure: MockStructure) -> None:
			with pytest.raises(PermissionError):
				vfs.hardlink(
					p(mock_structure.path / "dir2"), p(mock_structure.path / "hard2")
				)

		def test_symlink_file(
			self, vfs: VirtualFS, mock_structure: MockStructure
		) -> None:
			with pytest.raises(PermissionError):
				vfs.hardlink(
					p(mock_structure.path / "symA"), p(mock_structure.path / "hardA")
				)

		def test_symlink_dir(
			self, vfs: VirtualFS, mock_structure: MockStructure
		) -> None:
			with pytest.raises(PermissionError):
				vfs.hardlink(
					p(mock_structure.path / "sym11"), p(mock_structure.path / "hard11")
				)

		def test_missing(self, vfs: VirtualFS, mock_structure: MockStructure) -> None:
			with pytest.raises(FileNotFoundError):
				vfs.hardlink(
					p(mock_structure.path / "dir3"), p(mock_structure.path / "hard3")
				)

		def test_parent_file(
			self, vfs: VirtualFS, mock_structure: MockStructure
		) -> None:
			with pytest.raises(NotADirectoryError):
				vfs.hardlink(
					p(mock_structure.path / "fileA"),
					p(mock_structure.path / "fileA" / "fileAA"),
				)

		def test_parent_missing(
			self, vfs: VirtualFS, mock_structure: MockStructure
		) -> None:
			with pytest.raises(NotADirectoryError):
				vfs.hardlink(
					p(mock_structure.path / "fileA"),
					p(mock_structure.path / "dir3" / "file3A"),
				)

		def test_exists(self, vfs: VirtualFS, mock_structure: MockStructure) -> None:
			with pytest.raises(FileExistsError):
				vfs.hardlink(
					p(mock_structure.path / "fileA"), p(mock_structure.path / "fileB")
				)

	class TestScandir(object):
		def test_real_root(self, vfs: VirtualFS, mock_structure: MockStructure) -> None:
			paths = {entry.path for entry in vfs.scandir(p(mock_structure.path))}

			assert paths == {
				mock_structure.path / "fileA",
				mock_structure.path / "fileB",
				mock_structure.path / "dir1",
				mock_structure.path / "dir2",
				mock_structure.path / "hardB",
				mock_structure.path / "hard1B",
				mock_structure.path / "symA",
				mock_structure.path / "sym1A",
				mock_structure.path / "sym11",
				mock_structure.path / "symsymA",
			}

		def test_real_dir2(self, vfs: VirtualFS, mock_structure: MockStructure) -> None:
			paths = {
				entry.path for entry in vfs.scandir(p(mock_structure.path / "dir2"))
			}

			assert paths == {
				mock_structure.path / "dir2" / "file2A",
			}

		def test_file(self, vfs: VirtualFS, mock_structure: MockStructure) -> None:
			with pytest.raises(NotADirectoryError):
				vfs.scandir(p(mock_structure.path / "fileA"))

		def test_missing(self, vfs: VirtualFS, mock_structure: MockStructure) -> None:
			with pytest.raises(FileNotFoundError):
				vfs.scandir(p(mock_structure.path / "dir3"))

		def test_real_delete(
			self, vfs: VirtualFS, mock_structure: MockStructure
		) -> None:
			vfs.delete(p(mock_structure.path / "dir2" / "file2A"))
			paths = {
				entry.path for entry in vfs.scandir(p(mock_structure.path / "dir2"))
			}

			assert paths == set()

		def test_real_mkdir(
			self, vfs: VirtualFS, mock_structure: MockStructure
		) -> None:
			vfs.mkdir(p(mock_structure.path / "dir2" / "dir22"))
			paths = {
				entry.path for entry in vfs.scandir(p(mock_structure.path / "dir2"))
			}

			assert paths == {
				mock_structure.path / "dir2" / "file2A",
				mock_structure.path / "dir2" / "dir22",
			}

		def test_real_symlink(
			self, vfs: VirtualFS, mock_structure: MockStructure
		) -> None:
			vfs.symlink(
				p(mock_structure.path / "fileA"),
				p(mock_structure.path / "dir2" / "symA"),
			)
			paths = {
				entry.path for entry in vfs.scandir(p(mock_structure.path / "dir2"))
			}

			assert paths == {
				mock_structure.path / "dir2" / "file2A",
				mock_structure.path / "dir2" / "symA",
			}

		def test_fake_dir(self, vfs: VirtualFS, mock_structure: MockStructure) -> None:
			vfs.mkdir(p(mock_structure.path / "dir3"))
			paths = {
				entry.path for entry in vfs.scandir(p(mock_structure.path / "dir3"))
			}

			assert paths == set()

		def test_fake_delete(
			self, vfs: VirtualFS, mock_structure: MockStructure
		) -> None:
			vfs.mkdir(p(mock_structure.path / "dir3"))
			vfs.mkdir(p(mock_structure.path / "dir3" / "dir31"))
			vfs.delete(p(mock_structure.path / "dir3" / "dir31"))
			paths = {
				entry.path for entry in vfs.scandir(p(mock_structure.path / "dir3"))
			}

			assert paths == set()

		def test_fake_mkdir(
			self, vfs: VirtualFS, mock_structure: MockStructure
		) -> None:
			vfs.mkdir(p(mock_structure.path / "dir3"))
			vfs.mkdir(p(mock_structure.path / "dir3" / "dir31"))
			paths = {
				entry.path for entry in vfs.scandir(p(mock_structure.path / "dir3"))
			}

			assert paths == {
				mock_structure.path / "dir3" / "dir31",
			}

		def test_fake_symlink(
			self, vfs: VirtualFS, mock_structure: MockStructure
		) -> None:
			vfs.mkdir(p(mock_structure.path / "dir3"))
			vfs.symlink(
				p(mock_structure.path / "fileA"),
				p(mock_structure.path / "dir3" / "symA"),
			)
			paths = {
				entry.path for entry in vfs.scandir(p(mock_structure.path / "dir3"))
			}

			assert paths == {
				mock_structure.path / "dir3" / "symA",
			}


if __name__ == "__main__":
	pytest.main([__file__])
