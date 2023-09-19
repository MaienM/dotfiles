#!/usr/bin/env bash

set -e
shopt -s extglob

# shellcheck source=../../local/bin/commands_require
. commands_require
commands_require rofi

choice="$(
	(
		echo '4:3'
		echo '5:4'
		echo '5:3 (3DS top screen)'
		echo '3:2 (GBA)'
		echo '16:10'
		echo '16:9'
		echo '21:9'
		echo '32:9'
	) \
		| rofi -dmenu -p 'Pick an aspect ratio' -i
)"
choice="${choice%% *}"

case "$choice" in
	+([0-9]):+([0-9])) ~/.config/i3/resize-to-aspect-ratio.sh "$choice" "$1" ;;
	+([0-9])x+([0-9])) ~/.config/i3/resize-exact.sh "${choice%x*}" "${choice#*x}" ;;
	*)
		echo >&2 "Invalid input"
		exit 1
		;;
esac
