#!/usr/bin/env bash

set -o errexit -o pipefail

num_workspaces=12
command_teplate="$1"

declare -A workspaces
while
	read -r num
	read -r name
do
	workspaces[$num]="$name"
done < <(grep 'set $workspace' ~/.config/i3/baseconfig | cut -c15- | sed 's/\s/\n/')

source_workspace="$(i3-msg -t get_workspaces | jq 'map(select(.focused))[0].num')"

target_workspace="$(((source_workspace + num_workspaces - 1) % (2 * num_workspaces) + 1))"
target_workspace="${workspaces[$target_workspace]:-$target_workspace}"

command="$(echo "$command_teplate" | sed "s/__source__/$source_workspace/g; s/__target__/$target_workspace/g")"
eval "$command"
