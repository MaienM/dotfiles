#
# Force English as language.
#
export LANG=en_US.UTF-8
export LC_ALL=en_US.UTF-8

#
# Helper methods.
#

command-exists() {
	which "$@" &> /dev/null
}

in-path() {
	case ":$PATH:" in
		*":$1:"*)
			return 0  # zero return code -> success
		;;
		*)
			return 1  # non-zero return code -> failure
		;;
	esac
}
prepend-to-path() {
	in-path "$1" || export PATH="$1:$PATH"
}
append-to-path() {
	in-path "$1" || export PATH="$PATH:$1"
}

#
# Set preferred programs.
#
if command-exists nvim; then
	export EDITOR="nvim"
elif command-exists vim; then
	export EDITOR="vim"
elif command-exists vi; then
	export EDITOR="vi"
fi

if command-exists kitty; then
	export TERMINAL="kitty"
fi

#
# Add local bin to path.
#
prepend-to-path "$HOME/.local/bin"

#
# If present, load the profile file for this specific computer.
#
[ -f $HOME/.profile_local ] && source $HOME/.profile_local;

#
# If present, setup pyenv.
#
if [ -d $HOME/.pyenv ]; then
	export PYENV_ROOT="$HOME/.pyenv"
	bindir="$PYENV_ROOT/bin"
	if ! in-path "$bindir"; then
		prepend-to-path "$bindir"
		export PYTHON_CONFIGURE_OPTS="--enable-shared"
		eval "$(pyenv init -)"
	fi
fi

#
# If present, setup rbenv.
#
if [ -d $HOME/.rbenv ]; then
	export RBENV_ROOT="$HOME/.rbenv"
	bindir="$RBENV_ROOT/bin"
	if ! in-path "$bindir"; then
		prepend-to-path "$bindir"
		eval "$(rbenv init -)"
	fi
fi

#
# If present, setup nodenv.
#
if [ -d $HOME/.nodenv ]; then
	export NODENV_ROOT="$HOME/.nodenv"
	bindir="$NODENV_ROOT/bin"
	if ! in-path "$bindir"; then
		prepend-to-path "$bindir"
		eval "$(nodenv init -)"
	fi
fi

#
# If present, setup java environment variables.
#
which java &> /dev/null && export JAVA_HOME=$(readlink -f "$(which java)" | sed "s:/bin/java::")
which javac &> /dev/null && export JDK_HOME=$(readlink -f "$(which javac)" | sed "s:/bin/javac::")
[ -x /usr/libexec/java_home ] && export JAVA_HOME=$(/usr/libexec/java_home -v 1.8)
[ -d "$HOME/.local/share/android-sdk-linux" ] && export ANDROID_HOME="$HOME/.local/share/android-sdk-linux" 

#
# If present, load the post profile file for this specific computer.
#
[ -f $HOME/.profile_local_post ] && source $HOME/.profile_local_post;
