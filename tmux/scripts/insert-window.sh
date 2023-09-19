#!/usr/bin/env sh

current="$(tmux display-message -p -F '#I')"
target="$1"
while tmux list-panes -t "$target"; do
	tmux swap-window -s "$current" -t "$target"
	target="$((target + 1))"
done
tmux select-window -t "$1"
