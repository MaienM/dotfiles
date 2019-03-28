#!/usr/bin/env sh

set -o errexit -o pipefail

command_teplate="$1"
source_workspace="$(i3-msg -t get_workspaces | jq 'map(select(.focused))[0].num')"
target_workspace="$(((source_workspace + 10) % 20))"
command="$(echo "$command_teplate" | sed "s/__source__/$source_workspace/g; s/__target__/$target_workspace/g")"

eval "$command"

