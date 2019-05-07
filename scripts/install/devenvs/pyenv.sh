#!/usr/bin/env sh

set -e

clone() {
	[ -d "$2" ] || git clone "$1" "$2"
}

curl -L https://raw.githubusercontent.com/yyuu/pyenv-installer/master/bin/pyenv-installer | bash
clone https://github.com/montefra/pyenv-pyqt-build ~/.pyenv/plugins/pyenv-pyqt-build

