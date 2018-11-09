#!/usr/bin/env sh

set -o errexit -o pipefail

target="$1"
output="$(i3-msg -t get_workspaces | jq 'map(select(.focused))[0].output')"

i3-msg "move workspace to output $target; focus output $output"
