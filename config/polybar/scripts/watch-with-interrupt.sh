#!/usr/bin/env bash

# This script runs another script on a given interval. In addition it can be sent a signal to update sooner.

usage() {
	echo >&2 "Usage: $0 [names ...] [interval] [command args ...]"
	echo >&2 "name is the handle used when sending an update interrupt."
	echo >&2 "  it must only contain characters from the set [a-zA-Z0-9_-]."
	echo >&2 "interval is the time between updates in seconds, must be a number > 0."
	echo >&2 "command is the command or script to be run."
	echo >&2 "any additional arguments are passed as arguments to script."
}

names=()
while [ -n "$1" ] && ! [ "$1" -gt 0 ]; do
	if [[ ! "$1" =~ [a-zA-Z0-9_-]* ]]; then
		usage
		>&2 echo "ERROR: name '$1' contains invalid characters."
		exit 1
	fi

	names=("${names[@]}" "$1")
	shift 1
done
if [ "${#names[@]}" -eq 0 ]; then
	usage
	>&2 echo "ERROR: No names provided."
	exit 1
fi

interval="$1"
shift 1
if [ ! "$interval" -gt 0 ]; then
	usage
	echo >&2 "ERROR: invalid interval."
	exit 1
fi

command=("$@")

for name in "${names[@]}"; do
	path_pid="/tmp/polybar-watch-with-interrupt-$name.pid"
	echo $$ > "$path_pid"
	trap "rm '$path_pid'" EXIT
done

trap 'true' USR1

while true; do
	"${command[@]}"
	sleep "$interval" &
	wait
done
