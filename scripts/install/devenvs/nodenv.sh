#!/usr/bin/env sh

set -e

clone() {
	[ -d "$2" ] || git clone "$1" "$2"
}

clone https://github.com/nodenv/nodenv.git ~/.nodenv
clone https://github.com/nodenv/node-build.git ~/.nodenv/plugins/node-build
clone https://github.com/nodenv/nodenv-update.git ~/.nodenv/plugins/nodenv-update
