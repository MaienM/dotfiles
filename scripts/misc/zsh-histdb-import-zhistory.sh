#!/usr/bin/env bash

set -o errexit -o pipefail

echo ">>> Running history import."
installdir="$(mktemp -d)"
git clone https://github.com/phiresky/ts-histdbimport "$installdir"
(
	cd "$installdir"
	npm install
	npm run insert-all
)
