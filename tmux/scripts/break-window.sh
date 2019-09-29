#!/usr/bin/env sh

set -e

CURRENT_SESSION="$1"
CURRENT_WINDOW="$2"
TARGET_SESSION_NAME="$3"

if ! error="$(tmux list-panes -t "$CURRENT_WINDOW" 2>&1 > /dev/null)"; then
	echo "Cannot find window. Reason: $error."
	exit 1
fi

if [ "$(tmux list-windows -t "$CURRENT_SESSION" | wc -l)" -eq 1 ]; then
	echo "Can't break the only existing window away from a session."
	exit 1
fi

if ! error="$(tmux new-session -d -s "$TARGET_SESSION_NAME" 2>&1 > /dev/null)"; then
	echo "Unable to create new session. Reason: $error."
	exit 1
fi

created_window="$(tmux list-panes -t "$TARGET_SESSION_NAME" -F '#S:#I')"
tmux swap-window -s "$CURRENT_WINDOW" -t "$created_window"
tmux kill-window -t "$CURRENT_WINDOW"
tmux switch-client -t "$created_window"

