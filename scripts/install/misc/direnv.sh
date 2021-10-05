#!/usr/bin/env bash

set -o errexit -o pipefail

# shellcheck source=../_asdf_utils.sh
source scripts/install/_asdf_utils.sh

echo ">>> Checking dependencies."
asdf_guard
asdf_plugin_add direnv

echo ">>> Installing latest direnv."
asdf_install_latest_version direnv
asdf reshim direnv "$version"
asdf global direnv "$version"
echo "Using direnv $version."

