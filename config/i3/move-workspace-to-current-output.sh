#!/usr/bin/env sh

set -o errexit -o pipefail

output="$(i3-msg -t get_workspaces | jq 'map(select(.focused))[0].output')"

for workspace in "$@"; do
	i3-msg "workspace $workspace; move workspace to output $output"
done
