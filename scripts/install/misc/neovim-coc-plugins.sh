#!/usr/bin/env sh

mtime() {
	stat --printf '%Y' "$1" 2> /dev/null || echo 0
}

set -e
for dir in vim/bundle-coc/*; do
	(
		set -e
		cd "$dir"
		if [ "$(mtime package.json)" -lt "$(mtime node_modules)" ]; then
			echo "$dir is already up-to-date."
			exit 0
		fi
		echo "$dir needs updating."
		run-in-asdf nodejs neovim yarn
	)
done
