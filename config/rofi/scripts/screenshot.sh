#!/usr/bin/env bash
# shellcheck disable=SC2154

set -e

screenshotdir="$HOME/Screenshots"

if [ ! -d "$screenshotdir" ]; then
	mkdir -p "$screenshotdir"
fi

# shellcheck source=../../../local/bin/commands_require
. commands_require; commands_require rofi scrot maim
# shellcheck disable=SC1091
. nerdfonts_icons_material

choice="$(~/.config/rofi/scripts/iconmenu.sh \
	"area mdi_crop Crop" \
	"window mdi_window_maximize Window" \
	"monitor mdi_monitor Monitor" \
	"all mdi_monitor_multiple All monitors" \
)" || exit 0

declare -a cmd
delay=0
case "$choice" in 
	"area") cmd=(maim -s) ;;
	"window") delay=3 cmd=(maim -i "$(xdotool getactivewindow)") ;;
	"monitor") delay=3 cmd=(scrot) ;;
	"all") cmd=(maim) ;;
esac

id=0
while [ $delay -gt 0 ]; do
	id="$(
		notify-send.py \
			--replaces-id "$id" \
			--urgency low \
			"Screenshot in $delay..." \
	)"
	sleep 1
	: $((delay-=1))
done

tmp="$(mktemp --suffix '.png')"
notify-error "${cmd[@]}" "$tmp"

fn="$screenshotdir/$(date +'%Y-%m-%dT%H:%M:%S%z')-$(identify -format '%wx%h' "$tmp").png"
mv "$tmp" "$fn"

printf '%s' "$fn" | xclip -selection Clipboard
(
	notify-send.py \
		'Screenshot' \
		--replaces-id "$id" \
		--icon "$fn" \
		--action default:Open delete:Delete
) | (
	read -r action
	read -r id
	case "$action" in
		default) image-view "$fn" ;;
		delete) 
			rm "$fn"
			notify-send.py \
				--replaces-id "$id" \
				--urgency low \
				'Screenshot deleted'
		;;
	esac
)
