#!/usr/bin/env bash

set -o errexit

# Install the colors.
cp ~/.zsh/bundle/base16-hooks/base16-xresources/xresources/base16-$BASE16_THEME-256.Xresources ~/.Xresources.d/colors

# Apply the Xresources.
xrdb -merge ~/.Xresources
