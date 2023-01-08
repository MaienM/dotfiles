#!/usr/bin/env sh

if command -v checkupdates > /dev/null 2>&1; then
	echo
	exit 0
fi

prefix="${prefix:-}"
arch=$(checkupdates | wc -l)
aur=$(pikaur -Qua 2> /dev/null | wc -l)

if [ "$arch" -gt 0 ] || [ "$aur" -gt 0 ]; then
	echo "$prefix$arch/$aur"
else
	echo
fi
