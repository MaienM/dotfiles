#!/usr/bin/env bash

PANE_PID="$1"

exit_safely_if_empty_ppid() {
	if [ -z "$PANE_PID" ]; then
		exit 0
	fi
}

get_child_pids() {
	ps -awwo ppid=,pid= \
		| awk -v ppid="$1" '{ if ($1 == ppid) print $2 }' \
		| while read -r pid; do
			printf '%s\n' "$pid"
			get_child_pids "$pid"
		done
}

full_command() {
	pid="$(
		get_child_pids "$PANE_PID" \
			| xargs --no-run-if-empty ps -wwo pid=,stat= -p \
			| grep '+\s*$' \
			| awk '{ print $1 }' \
			| xargs --no-run-if-empty ps -wwo pid= \
			| tail -n1 \
			| tr -d '[:space:]'
	)"
	mapfile -t -d '' args < "/proc/${pid## }/cmdline"
	printf '%q ' "${args[@]}"
}

main() {
	exit_safely_if_empty_ppid
	full_command
}
main
