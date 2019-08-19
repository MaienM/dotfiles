#!/usr/bin/env sh

find_latest_env_version() {
	envcommand="$1"
	filter="$2"

	"$envcommand" install -l | grep "$filter" | tail -n1 | tr -d ' '
}

