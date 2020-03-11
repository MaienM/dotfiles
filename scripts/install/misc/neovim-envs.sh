#!/usr/bin/env bash

set -o errexit -o pipefail

# shellcheck source=../../../profile.d/asdf
source profile.d/asdf
# shellcheck source=_utils.sh
source scripts/install/misc/_utils.sh

echo ">>> Checking dependencies."
asdf_guard
asdf_plugin_add python ruby nodejs

echo ">>> Installing latest python 2.x."
asdf_install_latest_version python '^\s*2\.[0-9.]\+\s*$'
py2_version="$version"
echo "Using python $py2_version."

echo ">>> Installing latest python 3.x."
asdf_install_latest_version python '^\s*3\.[0-9.]\+\s*$'
py3_version="$version"
echo "Using python $py3_version."

echo ">>> Installing latest ruby."
asdf_install_latest_version ruby
rb_version="$version"
echo "Using ruby $rb_version."

echo ">>> Installing latest nodejs."
asdf_install_latest_version nodejs
nodejs_version="$version"
echo "Using nodejs $nodejs_version."

echo ">>> Setting up python $py2_version"
asdf_remove_virtualenv neovim2
ASDF_PYTHON_VERSION="$py2_version" asdf install python-venv neovim2
ASDF_PYTHON_VERSION=neovim2 asdf exec pip install pynvim
py2_path=$(ASDF_PYTHON_VERSION=neovim2 asdf which python)

echo ">>> Setting up python $py3_version"
asdf_remove_virtualenv neovim3
ASDF_PYTHON_VERSION="$py3_version" asdf install python-venv neovim3
ASDF_PYTHON_VERSION=neovim3 asdf exec pip install pynvim
py3_path=$(ASDF_PYTHON_VERSION=neovim3 asdf which python)

echo ">>> Setting up ruby $rb_version"
ASDF_RUBY_VERSION="$rb_version" asdf exec gem install neovim

echo ">>> Setting up nodejs $nodejs_version"
ASDF_NODEJS_VERSION="$nodejs_version" asdf exec npm install -g neovim

echo ">>> Done! Add the following lines to your neovim init to use the new environments:"
echo "let g:python_host_prog = '$py2_path'"
echo "let g:python3_host_prog = '$py3_path'"
