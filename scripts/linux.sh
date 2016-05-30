#!/bin/bash

# Install pyenv
if [[ ! -d $HOME/.pyenv ]]; then
  curl -L https://raw.githubusercontent.com/yyuu/pyenv-installer/master/bin/pyenv-installer | bash;
  source ~/.profile
fi

# Install python 2.7
pyenv install 2.7
pyenv global 2.7

# Install powerline
pip2.7 install --user powerline-status

# Install fzf
git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf \&\& ~/.fzf/install

# Create links
bash scripts/link.sh
