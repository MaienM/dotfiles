#!/usr/bin/env bash
# shellcheck disable=SC2154

set -e

# shellcheck source=../../../local/bin/commands_require
. commands_require; commands_require rofi scrot
# shellcheck disable=SC1091
. nerdfonts_icons_material

choice="$(~/.config/rofi/scripts/iconmenu.sh \
	"area mdi_crop Crop" \
	"window mdi_window_maximize Window" \
	"monitor mdi_monitor Monitor" \
	"all mdi_monitor_multiple All monitors" \
)" || exit 0

delay=0
args=()
case "$choice" in 
	"area") args=(-s) ;;
	"window") args=(-c -u) delay=3 ;;
	"monitor") args=(-c) delay=3 ;;
	"all") args=(-m) ;;
esac

if [ "$delay" -gt 1 ]; then
	sleep "$delay"
fi

screenshotdir="$HOME/Screenshots"
if [ ! -d "$screenshotdir" ]; then
	mkdir -p "$screenshotdir"
fi

# shellcheck disable=SC2016
if fn="$(notify-error scrot "${args[@]}" -e 'echo $f')"; then
	ffn="$screenshotdir/$fn"
	mv "$fn" "$ffn"
	echo "$fn"
	printf '%s' "$ffn" | xclip -selection Clipboard
	notify-send "Screenshot" "Saved screenshot to $fn"
fi

