#!/usr/bin/env sh

arch=$(checkupdates | wc -l)
aur=$(pikaur -Qua --devel --needed 2> /dev/null | wc -l)

if [ "$arch" -gt 0 ] || [ "$aur" -gt 0 ]; then
	echo "$arch/$aur"
fi
