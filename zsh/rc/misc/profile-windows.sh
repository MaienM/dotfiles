#!/usr/bin/env sh

# WSL doesn't seem to properly setup everything, so correct this
if ! grep -q /proc/sys/kernel/osrelease Microsoft; then
	return;
fi

# DISPLAY will never be set, even if an X display is available
export DISPLAY=localhost:0

# Shell isn't set correctly
SHELL=$(command -v zsh)
export SHELL

# Use docker for windows
export DOCKER_HOST=tcp://0.0.0.0:2375

# There is no login session, so ~/.profile is never loaded
# shellcheck disable=SC1090
. ~/.profile
