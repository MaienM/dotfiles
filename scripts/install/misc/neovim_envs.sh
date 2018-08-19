#!/bin/bash

source ~/.profile

which pyenv &> /dev/null || (echo ">>> pyenv must be installed first"; exit 1)
which rbenv &> /dev/null || (echo ">>> rbenv must be installed first"; exit 1)

echo ">>> Determining versions..."
py2_version=$(pyenv install -l | grep '^\s*2\.[0-9.]\+\s*$' | tail -n1 | tr -d ' ')
py3_version=$(pyenv install -l | grep '^\s*3\.[0-9.]\+\s*$' | tail -n1 | tr -d ' ')
rb_version=$(rbenv install -l | grep '^\s*[0-9.]\+\s*$' | tail -n1 | tr -d ' ')
echo ">>> Using python $py2_version, python $py3_version, and ruby $rb_version"
if [ -z "$py2_version" ] || [ -z "$py3_version" ] || [ -z "$rb_version" ]; then
  echo ">>> Unable to determine some versions, aborting"
  exit 1;
fi

echo ">>> Installing..."
pyenv install --skip-existing $py2_version
pyenv install --skip-existing $py3_version
rbenv install --skip-existing $rb_version
echo ">>> Installations complete"

echo ">>> Setting up python $py2_version"
(
  set -o errexit
  pyenv virtualenv-delete -f neovim2 || true
  pyenv virtualenv $py2_version neovim2
  eval "$(pyenv init -)"
  pyenv activate neovim2
  pip install neovim
)
py2_path=$(pyenv which python)

echo ">>> Setting up python $py3_version"
(
  set -o errexit
  pyenv virtualenv-delete -f neovim3 || true
  pyenv virtualenv $py3_version neovim3
  eval "$(pyenv init -)"
  pyenv activate neovim3
  pip install neovim
)
py3_path=$(pyenv which python)

echo ">>> Setting up ruby $rb_version"
(
  set -o errexit
  eval "$(rbenv init -)"
  rbenv shell $rb_version
  gem install neovim
)
rb_path=$(rbenv which ruby)

echo ">>> Done! Add the following lines to your neovim init to use the new environments:"
echo "let g:python_host_prog = '$py2_path'"
echo "let g:python3_host_prog = '$py3_path'"
