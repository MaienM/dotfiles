#
# Load generic profile
#
if [ -f $HOME/.profile ]; do
  source $HOME/.profile;
fi

# Source bashrc.
. $HOME/.bashrc
