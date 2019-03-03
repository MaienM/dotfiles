#!/usr/bin/env sh

curl -L https://raw.githubusercontent.com/yyuu/pyenv-installer/master/bin/pyenv-installer | bash
[ -d "$HOME/.pyenv/plugins/pyenv-pyqt-build" ] || git clone https://github.com/montefra/pyenv-pyqt-build "$HOME/.pyenv/plugins/pyenv-pyqt-build"

