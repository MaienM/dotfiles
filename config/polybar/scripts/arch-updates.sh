#!/usr/bin/env sh

prefix="${prefix:-}"
arch=$(checkupdates | wc -l)
aur=$(pikaur -Qua 2> /dev/null | wc -l)

if [ "$arch" -gt 0 ] || [ "$aur" -gt 0 ]; then
	echo "$prefix$arch/$aur"
else
	echo
fi
