#!/usr/bin/env bash

# shellcheck source=_utils.sh
source ~/.tmux/scripts/_utils.sh

set -e

CURRENT_SESSION="$1"
CURRENT_WINDOW="$2"

if ! error="$(tmux list-panes -t "$CURRENT_WINDOW" 2>&1 > /dev/null)"; then
	tmux display-message "Cannot find window. Reason: $error."
	exit 0
fi

if [ "$(tmux list-windows -t "$CURRENT_SESSION" | wc -l)" -eq 1 ]; then
	tmux display-message "Can't break with only one window."
	exit 0
fi

TARGET_SESSION_NAME="$(tmux-command-prompt-capture -p '(break-window)' -I '#W')"

if ! error="$(tmux new-session -d -s "$TARGET_SESSION_NAME" 2>&1 > /dev/null)"; then
	tmux display-message "Unable to create new session. Reason: $error."
	exit 0
fi

created_window="$(tmux list-panes -t "$TARGET_SESSION_NAME" -F '#S:#I')"
tmux swap-window -s "$CURRENT_WINDOW" -t "$created_window"
tmux kill-window -t "$CURRENT_WINDOW"
tmux switch-client -t "$created_window"

