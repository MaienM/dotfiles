#!/usr/bin/env sh

set -e

. commands_require; commands_require xrdb 2> /dev/null || exit 0

ln -f "$HOME/.zsh/bundle/base16-hooks/base16-xresources/xresources/base16-$BASE16_THEME-256.Xresources" ~/.Xresources.d/colors
xrdb -merge ~/.Xresources
