#!/usr/bin/env sh

xrdb -query \
	| grep -E '^\*(color[0-9]+|foreground|background):' \
	| sed 's/^\*/export base16_/; s/:\s*/="/; s/$/"/' \
	> ~/.profile.d/base16
