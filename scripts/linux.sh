# Ask a question.
function ask()
{
  D=${1//[abcdefghijklmnopqrstuvwxyz]} # [a-z] didn't work as it also matched
                                       # uppercase letters.
  if [[ ${#D} -gt 1 ]]
  then
    echo "There are multiple defaults specified in this ask sequence: $1."
    return
  fi

  A='-'
  while [[ ${1,,} != *${A,,}* ]]
  do
    read -n1 A &> /dev/null
  done

  if [[ -z $A ]]
  then
    if [[ ${#D} -eq 1 ]]
    then
      A=$D
    else
      ask "$1"
    fi
  fi
  echo 
  A=${A,,}
}

# Ask about the system.
echo "Is this a desktop system? [Ny]"
ask "Ny"

# Build package list.
echo "aptitude" >> packages
echo "build-essential" >> packages
echo "cmake" >> packages
echo "dnsmasq" >> packages
echo "eclipse" >> packages
echo "git>2" >> packages
echo "mysql-server" >> packages
echo "nginx" >> packages
echo "node" >> packages
echo "npm" >> packages
echo "php5-fpm" >> packages
echo "phpmyadmin" >> packages
echo "python" >> packages
echo "python2.7" >> packages
echo "sed" >> packages
echo "silversearcher-ag" >> packages
echo "tmux" >> packages
echo "vim-nox" >> packages
echo "zsh>5" >> packages
if [[ $A == 'y' ]]
then
  echo "teamviewer9:i386" >> packages
  echo "spotify-client" >> packages
  echo "skype:i386" >> packages
  echo "opera" >> packages
  echo "konsole" >> packages
  echo "keepass2" >> packages
  echo "dropbox" >> packages
  echo "chromium" >> packages
fi

# Install dependencies.
echo "Installing dependencies."
sudo apt-get install < packages
rm packages

# Checkout dotfiles.
echo "Getting dotfiles."
if [[ ! -d ~/dotfiles ]]
then
	git clone git@github.com:MaienM/dotfiles.git ~/dotfiles
fi

# Setup links.
echo "Linking dotfiles to home folder."
sh ~/dotfiles/scripts/link.sh
