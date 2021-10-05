#!/usr/bin/env bash

set -o errexit -o pipefail

# shellcheck source=../_asdf_utils.sh
source scripts/install/_asdf_utils.sh

echo ">>> Checking dependencies."
asdf_guard
asdf_plugin_add golang

echo ">>> Installing latest golang."
asdf_install_latest_version golang
echo "Using golang $version."

echo ">>> Installing utilities."
ASDF_GOLANG_VERSION="$version" asdf exec go get github.com/edi9999/path-extractor/path-extractor
asdf reshim golang "$version"

