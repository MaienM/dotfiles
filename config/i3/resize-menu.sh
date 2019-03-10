#!/usr/bin/env bash

shopt -s extglob

error=$( (
	set -e

	choice="$(
		(
			echo '4:3'
			echo '5:4'
			echo '3:2 (GBA)'
			echo '16:10'
			echo '16:9'
			echo '21:9'
			echo '32:9'
		) | \
			rofi -dmenu -p 'Pick an aspect ratio' -i
	)"
	choice="${choice% *}"

	case "$choice" in
		+([0-9]):+([0-9])) ~/.config/i3/resize-to-aspect-ratio.sh "$choice" "$1" ;;
		+([0-9])x+([0-9])) ~/.config/i3/resize-exact.sh "${choice%x*}" "${choice#*x}" ;;
		*)
			echo >&2 "Invalid input"
			exit 1
		;;
	esac
) 2>&1)

# shellcheck disable=2181
if [ $? -ne 0 ] && [ -n "$error" ]; then
	notify-send --urgency=critical 'resize-menu' "$error"
fi
