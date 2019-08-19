#!/usr/bin/env bash

set -o errexit -o pipefail

# shellcheck disable=SC1090
source ~/.profile
#  shellcheck disable=SC1091
source scripts/install/misc/_utils.sh

echo ">>> Checking dependencies."
command -v pyenv &> /dev/null || (echo "pyenv must be installed first"; exit 1)
command -v rbenv &> /dev/null || (echo "rbenv must be installed first"; exit 1)
command -v nodenv &> /dev/null || (echo "nodenv must be installed first"; exit 1)

echo ">>> Determining versions."
py2_version="$(find_latest_env_version pyenv '^\s*2\.[0-9.]\+\s*$')"
py3_version="$(find_latest_env_version pyenv '^\s*3\.[0-9.]\+\s*$')"
rb_version="$(find_latest_env_version rbenv '^\s*[0-9.]\+\s*$')"
node_version="$(find_latest_env_version nodenv '^\s*[0-9.]\+\s*$')"
echo "Using python $py2_version, python $py3_version, ruby $rb_version, and node $node_version"
if [ -z "$py2_version" ] || [ -z "$py3_version" ] || [ -z "$rb_version" ] || [ -z "$node_version" ]; then
  echo >&2 "Unable to determine some versions, aborting"
  exit 1;
fi

echo ">>> Installing."
pyenv install --skip-existing "$py2_version"
pyenv install --skip-existing "$py3_version"
rbenv install --skip-existing "$rb_version"
nodenv install --skip-existing "$node_version"
echo "Installations complete"

echo ">>> Setting up python $py2_version"
pyenv virtualenv-delete -f neovim2 || true
pyenv virtualenv "$py2_version" neovim2
run-in-pyenv neovim2 pip install neovim
py2_path=$(pyenv which python)

echo ">>> Setting up python $py3_version"
pyenv virtualenv-delete -f neovim3 || true
pyenv virtualenv "$py3_version" neovim3
run-in-pyenv neovim3 pip install neovim
py3_path=$(pyenv which python)

echo ">>> Setting up ruby $rb_version"
(
  eval "$(rbenv init -)"
  rbenv shell "$rb_version"
  gem install neovim
)

echo ">>> Setting up node $node_version"
(
  eval "$(nodenv init -)"
  nodenv shell "$node_version"
  npm install -g neovim
)

echo ">>> Done! Add the following lines to your neovim init to use the new environments:"
echo "let g:python_host_prog = '$py2_path'"
echo "let g:python3_host_prog = '$py3_path'"

