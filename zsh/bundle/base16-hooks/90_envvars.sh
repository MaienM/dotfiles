#!/usr/bin/env sh

. commands_require; commands_require xrdb 2> /dev/null || exit 0

xrdb -query \
	| grep -E '^\*(color[0-9]+|foreground|background):' \
	| sed 's/^\*/export base16_/; s/:\s*/="/; s/$/"/' \
	> ~/.profile.d/base16
