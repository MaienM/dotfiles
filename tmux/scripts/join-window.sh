#!/usr/bin/env bash

set -e

CURRENT_SESSION="$1"
SOURCE_WINDOW="$2"

if ! error="$(tmux list-panes -t "$SOURCE_WINDOW" 2>&1 > /dev/null)"; then
	tmux display-message "Cannot find window. Reason: $error."
	exit 0
fi

for i in {1..999}; do
	target_window="$CURRENT_SESSION:$i"
	tmux list-panes -t "$target_window" > /dev/null 2>&1 || break
done

tmux \
	move-window -s "$SOURCE_WINDOW" -t "$target_window" \; \
	switch-client -t "$target_window"
