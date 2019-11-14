#!/usr/bin/env bash
# shellcheck disable=SC2154

set -e

# shellcheck disable=SC1091
. nerdfonts_icons_material

choice="$(~/.config/rofi/scripts/iconmenu.sh \
	"area mdi_crop Crop" \
	"window mdi_window_maximize Window" \
	"monitor mdi_monitor Monitor" \
	"all mdi_monitor_multiple All monitors" \
)"

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

# shellcheck disable=SC2016
if fn="$(notify-error scrot "${args[@]}" -e 'echo $f')"; then
	notify-send "Screenshot" "Saved screenshot to $fn"
fi

