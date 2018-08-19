#!/usr/bin/env bash

set -o errexit -o pipefail

# Load the environment variables for the icons
source nerdfonts_icons_all

# Grab all the environment variables exported by the nerdfonts script and convert them to tmux set-env commands
# i_some_name=A becomes set-env -g "i_some_name" "A"
# Only do so for ones that are used in the tmuxline, as these is significant overhead in setting all of them
mkdir -p ~/.cache/tmux
conf=$(cat ~/.tmux/tmuxline.conf)
set | grep '^i_' | sed 's/^\([^=]*\)=\(.*\)$/\1 \2/' | while read line; do
	line=($line)
	[[ $conf == *"${line[0]}"* ]] || continue
	echo "set-env -g '${line[0]}' '${line[1]}'"
done > ~/.cache/tmux/nerdfont_icons_all.tmux
