#
# Force English as language.
#
export LANG=en_US.UTF-8

#
# Add local folder to the path.
#
export PATH="$HOME/local:$PATH"
export XDG_DATA_DIRS="$HOME/local:$XDG_DATA_DIRS"

#
# If present, setup rbenv.
#
if [ -d $HOME/.rbenv ]; then
	export PATH="$HOME/.rbenv/bin:$PATH"
	eval "$(rbenv init -)"
fi

#
# If present, setup java environment variables.
#
if [ -n "$(which java)" ]; then
	export JAVA_HOME=$(readlink -f "$(which java)" | sed "s:/bin/java::")
fi
if [ -n "$(which javac)" ]; then
	export JDK_HOME=$(readlink -f "$(which javac)" | sed "s:/bin/javac::")
fi
if [ -d "$HOME/.local/share/android-sdk-linux" ]; then
	export ANDROID_HOME="$HOME/.local/share/android-sdk-linux" 
fi

#
# If present, load the profile file for this specific computer.
#
if [ -f $HOME/.profile_local ]; then
	source $HOME/.profile_local;
fi
