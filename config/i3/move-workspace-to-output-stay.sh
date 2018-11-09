#!/usr/bin/env sh

set -o errexit -o pipefail

target="$1"
output="$(i3-msg -t get_workspaces | jq 'map(select(.focused))[0].output')"

i3-msg "move workspace to output $target"

new_workspace="$(i3-msg -t get_workspaces | jq "map(select(.visible and .output == $output))[0].name")"

i3-msg "workspace $new_workspace"
