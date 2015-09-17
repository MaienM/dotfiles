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
# If present, setup RVM.
#

#
# If present, setup rbenv.
#
if [ -d $HOME/.rbenv ]; then
	export PATH="$HOME/.rbenv/bin:$PATH"
	eval "$(rbenv init -)"
fi

#
# If present, load the profile file for this specific computer.
#
if [ -f $HOME/.profile_local ]; then
	source $HOME/.profile_local;
fi
