#!/usr/bin/env cached-nix-shell
#!nix-shell -i bash
#!nix-shell -p imagemagick
#!nix-shell -p maim
#!nix-shell -p scrot
#!nix-shell -p xdotool
# shellcheck disable=SC2154

set -e

screenshotdir="$HOME/Screenshots"

if [ ! -d "$screenshotdir" ]; then
	mkdir -p "$screenshotdir"
fi

i_mdi_crop=f69d
i_mdi_window_maximize=f2d0
i_mdi_monitor=f878
i_mdi_monitor_multiple=f879
choice="$(
	~/.config/rofi/scripts/iconmenu.sh \
		"area $i_mdi_crop Crop" \
		"window $i_mdi_window_maximize Window" \
		"monitor $i_mdi_monitor Monitor" \
		"all $i_mdi_monitor_multiple All monitors"
)" || exit 0

declare -a cmd
delay=0
case "$choice" in
	"area") cmd=(maim -s) ;;
	"window") delay=3 cmd=(maim -i "$(xdotool getactivewindow)") ;;
	"monitor") delay=3 cmd=(scrot) ;;
	"all") cmd=(maim) ;;
	*)
		echo >&2 "Invalid choice $choice."
		exit 1
		;;
esac

id=0
while [ $delay -gt 0 ]; do
	id="$(
		notify-send.py \
			--replaces-id "$id" \
			--urgency low \
			"Screenshot in $delay..."
	)"
	sleep 1
	: $((delay -= 1))
done

tmp="$(mktemp --suffix '.png')"
echo notify-error "${cmd[@]}" "$tmp"
notify-error "${cmd[@]}" "$tmp"

fn="$screenshotdir/$(date +'%Y-%m-%dT%H:%M:%S%z')-$(identify -format '%wx%h' "$tmp").png"
mv "$tmp" "$fn"

printf '%s' "$fn" | xclip -selection Clipboard
notify-new-file "$fn" 'Screenshot'
