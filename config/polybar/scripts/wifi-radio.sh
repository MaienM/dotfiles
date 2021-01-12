#!/usr/bin/env sh

if [ "$(nmcli radio wifi)" = disabled ]; then
	echo ' '
else
	echo
fi
