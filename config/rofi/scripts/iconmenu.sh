#!/usr/bin/env bash

# Renders a rofi menu to pick between options, where the centerpoint is large icons.
#
# Usage: $0 option [option ...]
# Where each option is in the form of "id icon[:color][ description]".
# The output is the id of the chosen command.

set -o errexit -o pipefail

if [ "$#" -eq 1 ]; then
	echo >&2 "Cannot render icon menu without any icons."
	exit 1
fi

option_pattern="^([^ ]+)[ ]+([^ :]+)(:[^ ]+)?([ ]+(.*[^ ])[ ]*)?$"
for option in "$@"; do
	if ! [[ $option =~ $option_pattern ]]; then
		echo >&2 "Invalid argument '$option'."
		exit 1
	fi
	id="${BASH_REMATCH[1]}"
	icon="${BASH_REMATCH[2]}"
	icon_color="${BASH_REMATCH[3]+$base16_foreground}"
	description="${BASH_REMATCH[5]}"
	printf '<span size="0">%s</span>%s\0icon\x1f%s\n' \
		"$id" "$description" "$(nerdfonts-icon-as-svg "$icon" "$icon_color")"
done \
	| rofi \
		-dmenu \
		-theme <(~/.config/rofi/themes/iconmenu.sh "$#") \
		-markup-rows \
		-show-icons \
		-kb-move-char-back '' \
		-kb-move-char-forward '' \
		-kb-row-up Left,Up,h,k,Control+p \
		-kb-row-down Down,Right,j,l,Control+n \
	| sed 's/^<span size=.0.>\([^<]*\)<.*$/\1/'
