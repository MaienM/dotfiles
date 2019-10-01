#!/usr/bin/env bash

tmux-command-prompt-capture() {
	local path
	path="$(mktemp)"
	tmux command-prompt "$@" "run-shell \"printf '%s' '%%' > '$path'\""
	cat "$path"
}

