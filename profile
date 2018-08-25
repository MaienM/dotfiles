#!/usr/bin/env sh

#
# Setup autoloading functions.
#
for file in "$HOME/.functions"/*; do
	name=$(basename "$file")
	eval "$name() {
		unset \"$name\"
		. \"$file\"
		\"$name\" \"\$@\"
	}"
done

#
# Force English as language.
#
export LANG=en_US.UTF-8
export LC_ALL=en_US.UTF-8

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
# Add local bin to path.
#
prepend_to_path "$HOME/.local/bin"

#
# If present, load the profile file for this specific computer.
#
[ -f "$HOME/.profile_local" ] && . "$HOME/.profile_local";

#
# If present, setup pyenv.
#
if [ -d "$HOME/.pyenv" ]; then
	export PYENV_ROOT="$HOME/.pyenv"
	bindir="$PYENV_ROOT/bin"
	if ! in_path "$bindir"; then
		prepend_to_path "$bindir"
		export PYTHON_CONFIGURE_OPTS="--enable-shared"
		eval "$(pyenv init -)"
	fi
fi

#
# If present, setup rbenv.
#
if [ -d "$HOME/.rbenv" ]; then
	export RBENV_ROOT="$HOME/.rbenv"
	bindir="$RBENV_ROOT/bin"
	if ! in_path "$bindir"; then
		prepend_to_path "$bindir"
		eval "$(rbenv init -)"
	fi
fi

#
# If present, setup nodenv.
#
if [ -d "$HOME/.nodenv" ]; then
	export NODENV_ROOT="$HOME/.nodenv"
	bindir="$NODENV_ROOT/bin"
	if ! in_path "$bindir"; then
		prepend_to_path "$bindir"
		eval "$(nodenv init -)"
	fi
fi

#
# If present, load the post profile file for this specific computer.
#
[ -f "$HOME/.profile_local_post" ] && . "$HOME/.profile_local_post";
