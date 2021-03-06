#!/usr/bin/env sh
# shellcheck disable=SC1090

#
# Force English as language.
#
if locale -a | grep -q en_GB; then
	export LANG=en_GB.UTF-8
else
	export LANG=en_US.UTF-8
fi
export LC_ALL="$LANG"

#
# If present, load the profile file for this specific computer.
#
[ -f "$HOME/.profile_local" ] && . "$HOME/.profile_local";

#
# Load other profile files.
#
for file in "$HOME/.profile.d/"*; do
	. "$file"
done

#
# Set preferred programs.
#
if command_exists nvim; then
	export EDITOR="nvim"
elif command_exists vim; then
	export EDITOR="vim"
elif command_exists vi; then
	export EDITOR="vi"
fi

if command_exists kitty; then
	export TERMINAL="kitty"
fi

#
# Add local bin to path. This is done (almost) last, because it is unlikely that something should be before it.
#
prepend_to_path "$HOME/.local/bin"

#
# If present, load the post profile file for this specific computer.
#
[ -f "$HOME/.profile_local_post" ] && . "$HOME/.profile_local_post";
