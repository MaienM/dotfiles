#
# Force English as language.
#
export LANG=en_US.UTF-8
export LC_ALL=en_US.UTF-8

#
# Add local folder to the path.
#
export PATH="$HOME/local:$PATH"
export XDG_DATA_DIRS="$HOME/local:$XDG_DATA_DIRS"

# (Neo)vim. Need I say more?
which nvim &> /dev/null && export EDITOR="nvim" || export EDITOR="vim"

#
# If present, load the profile file for this specific computer.
#
[ -f $HOME/.profile_local ] && source $HOME/.profile_local;

#
# If present, setup pyenv.
#
if [ -d $HOME/.pyenv ]; then
	export PYENV_ROOT="$HOME/.pyenv"
	export PATH="$PYENV_ROOT/bin:$PATH"
	export PYTHON_CONFIGURE_OPTS="--enable-shared"
	eval "$(pyenv init -)"
fi

#
# If present, setup rbenv.
#
if [ -d $HOME/.rbenv ]; then
	export RBENV_ROOT="$HOME/.rbenv"
	export PATH="$RBENV_ROOT/bin:$PATH"
	eval "$(rbenv init -)"
fi

#
# If present, setup nodenv.
#
if [ -d $HOME/.nodenv ]; then
	export NODENV_ROOT="$HOME/.nodenv"
	export PATH="$NODENV_ROOT/bin:$PATH"
	eval "$(nodenv init -)"
fi

#
# If present, setup java environment variables.
#
[ -n "$(which java)" ] && export JAVA_HOME=$(readlink -f "$(which java)" | sed "s:/bin/java::")
[ -n "$(which javac)" ] && export JDK_HOME=$(readlink -f "$(which javac)" | sed "s:/bin/javac::")
[ -x /usr/libexec/java_home ] && export JAVA_HOME=$(/usr/libexec/java_home -v 1.8)
[ -d "$HOME/.local/share/android-sdk-linux" ] && export ANDROID_HOME="$HOME/.local/share/android-sdk-linux" 

#
# If present, load the post profile file for this specific computer.
#
[ -f $HOME/.profile_local_post ] && source $HOME/.profile_local_post;
