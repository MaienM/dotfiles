#!/usr/bin/env bash

set -o errexit -o pipefail

# shellcheck source=../../../profile.d/asdf
source profile.d/asdf
# shellcheck source=_utils.sh
source scripts/install/misc/_utils.sh

echo ">>> Checking dependencies."
asdf_guard
asdf_plugin_add direnv

echo ">>> Installing latest direnv."
asdf_install_latest_version direnv
asdf reshim direnv "$version"
asdf global direnv "$version"
echo "Using direnv $version."

