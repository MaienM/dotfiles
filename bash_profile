# Source the system /etc/profile.
. /etc/profile
. $HOME/.profile

# Change the path a bit.
export PATH="$HOME/bin:$PATH"

# Source bashrc.
. $HOME/.bashrc

[[ -s "$HOME/.rvm/scripts/rvm" ]] && source "$HOME/.rvm/scripts/rvm" # Load RVM into a shell session *as a function*
