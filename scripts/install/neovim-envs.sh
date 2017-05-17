#!/bin/bash

which pyenv &> /dev/null || (echo ">>> pyenv must be installed first"; exit 1)
which rbenv &> /dev/null || (echo ">>> rbenv must be installed first"; exit 1)

source ~/.profile

echo ">>> Determining versions..."
py2_version=$(pyenv install -l | grep '^\s*2.' | grep -v dev | tail -n1 | tr -d ' ')
py3_version=$(pyenv install -l | grep '^\s*3.' | grep -v dev | tail -n1 | tr -d ' ')
rb_version=$(rbenv install -l | grep '^\s*[0-9]' | grep -v dev | tail -n1 | tr -d ' ')
echo ">>> Using python $py2_version, python $py3_version, and ruby $rb_version"

echo ">>> Installing..."
pyenv install --skip-existing $py2_version
pyenv install --skip-existing $py3_version
rbenv install --skip-existing $rb_version
echo ">>> Installations complete"

echo ">>> Setting up python $py2_version"
pyenv uninstall -f neovim2
pyenv virtualenv $py2_version neovim2
pyenv activate neovim2
pip install neovim
py2_path=$(pyenv which python)

echo ">>> Setting up python $py3_version"
pyenv uninstall -f neovim3
pyenv virtualenv $py3_version neovim3
pyenv activate neovim3
pip install neovim
py3_path=$(pyenv which python)

echo ">>> Setting up ruby $rb_version"
rbenv shell $rb_version
gem install neovim
rb_path=$(rbenv which ruby)

echo ">>> Done! Add the following lines to your neovim init to use the new environments:"
echo "let g:python_host_prog = '$py2_path'"
echo "let g:python3_host_prog = '$py3_path'"
