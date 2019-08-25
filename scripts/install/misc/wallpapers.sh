#!/usr/bin/env sh

set -e

if [ ! -f "$1" ]; then
	echo >&2 "Usage: $0 [cookies.txt]"
	echo >&2 "The cookies.txt file must contain an active login session from wallhaven.cc"
	exit 1
fi

./scripts/install/misc/wallpapers.py "$1" "$HOME/local/share/backgrounds" 442033
