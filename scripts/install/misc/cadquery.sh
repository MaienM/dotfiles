#!/usr/bin/env bash

set -o errexit -o pipefail

cd ~/.dotfiles

# shellcheck source=../_asdf_utils.sh
source scripts/install/_asdf_utils.sh

echo ">>> Checking dependencies."
asdf_guard
asdf_plugin_add python

echo ">>> Installing latest miniconda."
asdf_install_latest_version python miniconda3
echo "Using miniconda $version."

echo ">>> Installing cadquery."
ASDF_PYTHON_VERSION="$version" asdf exec conda install -y -c conda-forge -c cadquery cadquery=master cq-editor=master
asdf reshim python "$version"

echo ">>> Creating shims."
for cmd in cq-editor CQ-editor; do
	printf '#/usr/bin/env sh\nASDF_PYTHON_VERSION=%q asdf exec %q "$@"\n' "$version" "$cmd" > "$HOME/.local/bin/$cmd"
	chmod +x "$HOME/.local/bin/$cmd"
done

