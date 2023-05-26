#!/usr/bin/env cached-nix-shell
#!nix-shell -i bash
#!nix-shell -p tmuxp

set -e

tmux list-windows -t "$1" > /dev/null

dir="$HOME/.tmux/frozen"
mkdir -p "$dir"
tmuxp freeze "$1" -f json -o "$dir/$1.json" -y

tmux kill-session -t "$1"
