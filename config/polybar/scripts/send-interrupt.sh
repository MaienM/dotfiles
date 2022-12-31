#!/usr/bin/env sh

# Companion script for watch-with-interrupt to send an interrupt.

name="$1"

if [ -z "$name" ]; then
	echo >&2 "Usage: $0 [name]"
	echo >&2 "name is the handle used for the watch-with-interrupt."
	exit 1
fi

path_pid="/tmp/polybar-watch-with-interrupt-$name.pid"
if [ ! -f "$path_pid" ]; then
	exit 1
fi

kill -USR1 "$(cat "$path_pid")"
