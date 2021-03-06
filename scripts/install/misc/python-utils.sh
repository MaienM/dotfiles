#!/usr/bin/env bash

set -o errexit -o pipefail

cd ~/.dotfiles

# shellcheck source=../../../profile.d/asdf
source profile.d/asdf
# shellcheck source=_utils.sh
source scripts/install/misc/_utils.sh

echo ">>> Checking dependencies."
asdf_guard
asdf_plugin_add python

echo ">>> Installing latest python."
asdf_install_latest_version python
echo "Using python $version."

echo ">>> Setting up virtualenv."
asdf_remove python-venv utils
ASDF_PYTHON_VERSION="$version" asdf install python-venv utils

echo ">>> Installing utilities."
ASDF_PYTHON_VERSION=utils asdf exec pip install -U bs4 requests lxml
ASDF_PYTHON_VERSION=utils asdf exec pip install -U tmuxp yq
ASDF_PYTHON_VERSION=utils asdf exec pip install -U dotsecrets
ASDF_PYTHON_VERSION=utils asdf exec pip install -U qmk
ASDF_PYTHON_VERSION=utils asdf exec pip install -U pybase16-builder
ASDF_PYTHON_VERSION=utils asdf exec pip install -U CurrencyConverter
asdf reshim python utils

