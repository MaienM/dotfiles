#!/usr/bin/env bash

set -o errexit -o pipefail

# shellcheck source=../../../profile.d/asdf
source profile.d/asdf
# shellcheck source=_utils.sh
source scripts/install/misc/_utils.sh

echo ">>> Checking dependencies."
command -v asdf &> /dev/null || (echo "asdf must be installed first"; exit 1)
asdf plugin-add python || true
asdf plugin-add ruby || true
asdf plugin-add nodejs || true
~/.asdf/plugins/nodejs/bin/import-release-team-keyring

echo ">>> Determining versions."
py2_version="$(find_latest_asdf_version python '^\s*2\.[0-9.]\+\s*$')"
py3_version="$(find_latest_asdf_version python '^\s*3\.[0-9.]\+\s*$')"
rb_version="$(find_latest_asdf_version ruby '^\s*[0-9.]\+\s*$')"
nodejs_version="$(find_latest_asdf_version nodejs '^\s*[0-9.]\+\s*$')"
echo "Using python $py2_version, python $py3_version, ruby $rb_version, and nodejs $nodejs_version"
if [ -z "$py2_version" ] || [ -z "$py3_version" ] || [ -z "$rb_version" ] || [ -z "$nodejs_version" ]; then
  echo >&2 "Unable to determine some versions, aborting"
  exit 1;
fi

echo ">>> Installing."
asdf install python "$py2_version"
asdf install python "$py3_version"
asdf install ruby "$rb_version"
asdf install nodejs "$nodejs_version"
echo "Installations complete"

echo ">>> Setting up python $py2_version"
remove_asdf_virtualenv neovim2
ASDF_PYTHON_VERSION="$py2_version" asdf install python-venv neovim2
ASDF_PYTHON_VERSION=neovim2 asdf exec pip install neovim
py2_path=$(ASDF_PYTHON_VERSION=neovim2 asdf which python)

echo ">>> Setting up python $py3_version"
remove_asdf_virtualenv neovim3
ASDF_PYTHON_VERSION="$py3_version" asdf install python-venv neovim3
ASDF_PYTHON_VERSION=neovim3 asdf exec pip install neovim
py3_path=$(ASDF_PYTHON_VERSION=neovim3 asdf which python)

echo ">>> Setting up ruby $rb_version"
ASDF_RUBY_VERSION="$rb_version" asdf exec gem install neovim

echo ">>> Setting up nodejs $nodejs_version"
ASDF_NODEJS_VERSION="$nodejs_version" asdf exec npm install -g neovim

echo ">>> Done! Add the following lines to your neovim init to use the new environments:"
echo "let g:python_host_prog = '$py2_path'"
echo "let g:python3_host_prog = '$py3_path'"

