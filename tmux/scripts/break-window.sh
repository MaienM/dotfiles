#!/usr/bin/env bash

set -e

CURRENT_WINDOW="$1"
CURRENT_SESSION="${CURRENT_WINDOW%:*}"
TARGET_SESSION_NAME="$2"

if ! error="$(tmux list-panes -t "$CURRENT_WINDOW" 2>&1 > /dev/null)"; then
	tmux display-message "Cannot find window: $error."
	exit 0
fi

if [ "$(tmux list-windows -t "$CURRENT_SESSION" | wc -l)" -eq 1 ]; then
	tmux display-message "Can't break with only one window."
	exit 0
fi

if [ -z "$TARGET_SESSION_NAME" ]; then
	set +e
	tmux command-prompt -p '(break-window)' -I '#W' "run '$0 '$CURRENT_WINDOW' '%%''"
	exit 0
fi

if ! error="$(tmux new-session -d -s "$TARGET_SESSION_NAME" 2>&1 > /dev/null)"; then
	tmux display-message "Unable to create new session: $error."
	exit 0
fi
created_window="$(tmux list-panes -t "$TARGET_SESSION_NAME" -F '#S:#I' | head -n1)"

if ! error="$(tmux \
	swap-window -t "$CURRENT_WINDOW" -s "$created_window" \; \
	switch-client -t "$created_window" \; \
	kill-window -t "$CURRENT_WINDOW" 2>&1 > /dev/null)"; then
	tmux kill-session -t "$TARGET_SESSION_NAME"
	tmux display-message "Failed to break window: $error."
fi
