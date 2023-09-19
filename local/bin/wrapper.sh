#!/usr/bin/env bash

# Helper script for scripts in ~/.local/bin/ that wrap an existing executable.

{
	set +e

	# Verify that the script is in ~/.local/bin/
	script_path="$(command -v "$0")"
	if ! [[ $script_path == "$HOME/.local/bin/"* ]]; then
		>&2 echo "Wrapper helper included from script that is not in ~/.local/bin/"
		exit 1
	fi

	# Find the wrapped executable.
	ORIG_BIN="$({
		# shellcheck source=../../functions/remove_from_path
		. ~/.functions/remove_from_path

		remove_from_path "^$HOME/.local/bin" "E"
		command -v "$(basename "$0")"
	})"

	# If no wrapped executable is found remove the script and abort.
	if [ -z "$ORIG_BIN" ]; then
		rm "$script_path"
		exec "$(basename "$0")" "$@" # This should result in a command not found error.
	fi

	# Clean up temp var.
	script_path=
}

# Setup done. The rest of the wrapper script may now run, and it can exec "$ORIG_BIN" ... when it's ready to call the wrapped executable.
