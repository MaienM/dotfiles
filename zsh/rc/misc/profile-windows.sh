#!/usr/bin/env sh

# WSL does not have a login session, so ~/.profile is never loaded, so do so now
if grep -q /proc/sys/kernel/osrelease Microsoft; then
	echo Loading profile...
	export DISPLAY=localhost:0
	SHELL=$(command -v zsh)
	export SHELL
	# shellcheck source=/dev/null
	. ~/.profile
fi
