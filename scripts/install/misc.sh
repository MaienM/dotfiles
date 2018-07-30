#!/bin/sh

bash ~/.fzf/install --bin

wget https://raw.githubusercontent.com/so-fancy/diff-so-fancy/master/third_party/build_fatpack/diff-so-fancy \
	-O ~/.local/bin/diff-so-fancy
chmod +x ~/.local/bin/diff-so-fancy
