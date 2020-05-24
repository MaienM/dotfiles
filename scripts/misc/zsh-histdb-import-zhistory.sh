#!/usr/bin/env bash

set -o errexit -o pipefail

# shellcheck source=../../profile.d/asdf
source profile.d/asdf
# shellcheck source=../install/misc/_utils.sh
source scripts/install/misc/_utils.sh

echo ">>> Checking dependencies."
asdf_guard
asdf_plugin_add nodejs

echo ">>> Installing latest nodejs."
asdf_install_latest_version nodejs
echo "Using nodejs $version."

echo ">>> Running history import."
installdir="$(mktemp -d)"
git clone https://github.com/phiresky/ts-histdbimport "$installdir"
(
	cd "$installdir"
	ASDF_NODEJS_VERSION="$version" asdf exec npm install
	ASDF_NODEJS_VERSION="$version" history_file="$HOME/.zhistory" asdf exec npm run insert-all
)

