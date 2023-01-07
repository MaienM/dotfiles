#!/usr/bin/env bash

zshpath="$HOME/.zsh/bundle/fzf"
vimpath="$HOME/.vim/bundle/fzf-base"

rm -rf "$zshpath" "$vimpath"

git clone --depth 1 https://github.com/junegunn/fzf.git "$zshpath"
ln -s "$zshpath" "$vimpath"

"$zshpath"/install
