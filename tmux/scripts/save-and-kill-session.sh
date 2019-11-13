#!/usr/bin/env sh

set -e

if ! error="$(tmux list-windows -t "$1" 2>&1 > /dev/null)"; then
	echo tmux display-message "Cannot find session: $error."
	exit 0
fi

dir="$HOME/.tmux/frozen"
mkdir -p "$dir"
if ! error="$(~/.tmux/scripts/tmuxp-freeze.py "$1" "$dir/$1.json" 2>&1 > /dev/null)"; then
	echo tmux display-message "Cannot save session: $error."
	exit 0
fi

tmux kill-session -t "$1"

