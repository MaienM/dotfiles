#!/usr/bin/env bash

PANE_PID="$1"

exit_safely_if_empty_ppid() {
	if [ -z "$PANE_PID" ]; then
		exit 0
	fi
}

full_command() {
	ps --forest -g "$PANE_PID" -o pid,stat \
		| grep '+$' \
		| awk '{ print $1 }' \
		| xargs --no-run-if-empty ps -o cmd --no-headers \
		| tail -n1
}

main() {
	exit_safely_if_empty_ppid
	full_command
}
main
