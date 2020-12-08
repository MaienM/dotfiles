#!/usr/bin/env bash

# This script runs another script on a given interval. In addition it can be sent a signal to update sooner.

name="$1"
interval="$2"
shift 2
command=("$@")

usage() {
	echo >&2 "Usage: $0 [name] [interval] [command args ...]"
	echo >&2 "name is the handle used when sending an update interrupt."
	echo >&2 "  it must only contain characters from the set [a-zA-Z0-9_-]."
	echo >&2 "interval is the time between updates in seconds, must be a number > 0."
	echo >&2 "command is the command or script to be run."
	echo >&2 "any additional arguments are passed as arguments to script."
}
if [ -z "$name" ]; then
	usage
	echo >&2 "ERROR: name is required."
	exit 1
fi
if [[ ! "$name" =~ [a-zA-Z0-9_-]* ]]; then
	usage
	echo >&2 "ERROR: name contains invalid characters."
	exit 1
fi
if [ ! "$interval" -gt 0 ]; then
	usage
	echo >&2 "ERROR: invalid interval."
	exit 1
fi

path_pid="/tmp/polybar-watch-with-interrupt-$name.pid"
echo $$ > "$path_pid"

trap 'exit && rm "$path_pid"' INT
trap 'true' USR1

while true; do
	"${command[@]}"
	sleep "$interval" &
	wait
done
