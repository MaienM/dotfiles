#!/usr/bin/env sh

#
# Force English as language.
#
export LANG=en_US.UTF-8
export LC_ALL=en_US.UTF-8

#
# Helper methods.
#

command_exists() {
	command -v "$@" > /dev/null 2>&1 
}

in_path() {
	case ":$PATH:" in
		*":$1:"*)
			return 0  # zero return code -> success
		;;
		*)
			return 1  # non-zero return code -> failure
		;;
	esac
}
prepend_to_path() {
	in_path "$1" || export PATH="$1:$PATH"
}
append_to_path() {
	in_path "$1" || export PATH="$PATH:$1"
}

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
