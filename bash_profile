#
# Load generic profile
#
if [ -f $HOME/.profile ]; then
  source $HOME/.profile;
fi

# Source bashrc.
. $HOME/.bashrc
