#!/usr/bin/env bash

set -o errexit -o pipefail

#  shellcheck disable=SC1091
source scripts/install/misc/_utils.sh

command -v pyenv &> /dev/null || (echo ">>> pyenv must be installed first"; exit 1)

echo ">>> Determining version."
py_version="$(find_latest_env_version pyenv '^\s*3\.[0-9.]\+\s*$')"
echo "Using python $py_version."
if [ -z "$py_version" ]; then
  echo "Unable to determine version, aborting"
  exit 1;
fi

echo ">>> Installing."
pyenv install --skip-existing "$py_version"
echo "Installation complete"

echo ">>> Setting up virtualenv"
pyenv virtualenv-delete -f utils || true
pyenv virtualenv "$py_version" utils
run-in-pyenv utils pip install pygments pygments-base16 

