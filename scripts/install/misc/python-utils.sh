#!/usr/bin/env bash

set -o errexit -o pipefail

# shellcheck source=../../../profile.d/asdf
source profile.d/asdf
# shellcheck source=_utils.sh
source scripts/install/misc/_utils.sh

echo ">>> Determining version."
py_version="$(find_latest_asdf_version python '^\s*3\.[0-9.]\+\s*$')"
echo "Using python $py_version."
if [ -z "$py_version" ]; then
	echo "Unable to determine version, aborting"
	exit 1;
fi

echo ">>> Installing."
asdf install python "$py_version"
echo "Installation complete"

echo ">>> Setting up virtualenv."
remove_asdf_virtualenv utils
ASDF_PYTHON_VERSION="$py_version" asdf install python-venv utils

echo ">>> Installing utilities."
ASDF_PYTHON_VERSION=utils asdf exec pip install bs4 requests lxml
ASDF_PYTHON_VERSION=utils asdf exec pip install pygments pygments-base16 
asdf reshim python utils

