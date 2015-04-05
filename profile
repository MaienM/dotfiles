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
# If present, load the profile file for this specific computer.
#
if [ -f $HOME/.profile_local ]; then
	source $HOME/.profile_local;
fi
