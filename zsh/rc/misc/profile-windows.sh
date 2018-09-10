#!/usr/bin/env sh

# WSL doesn't seem to properly setup everything, so correct this
if grep -q /proc/sys/kernel/osrelease Microsoft; then
	# DISPLAY will never be set, even if an X display is available
	export DISPLAY=localhost:0

	# Shell isn't set correctly
	SHELL=$(command -v zsh)
	export SHELL

	# There is no login session, so ~/.profile is never loaded
	# shellcheck disable=SC1090
	. ~/.profile
fi
