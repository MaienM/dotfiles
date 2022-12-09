#!/usr/bin/env bash

. commands_require; commands_require polybar 2> /dev/null || exit 0

# Terminate already running bar instances
pkill -f bin/polybar

# Wait until the processes have been shut down
while pgrep -u $UID -x polybar >/dev/null; do sleep 1; done

# Load the icons
set -a
# shellcheck disable=SC1091
source nerdfonts_icons_all
set +a

# Make the colors available as environment variables
# shellcheck disable=SC1090
source ~/.profile.d/base16

# Get the names of the available physical network interfaces.
mapfile -t eths < <(find /sys/class/net -type l -not -lname '*virtual*' -not -name 'w*' -printf '%f\n')
mapfile -t wlans < <(find /sys/class/net -type l -not -lname '*virtual*' -name 'w*' -printf '%f\n')
for i in {0..2}; do
	declare -x "eth$i=${eths[i]}"
	declare -x "wlan$i=${wlans[i]}"
done

# Launch bars for all screens
mapfile -t monitors < <(xrandr --listmonitors | cut -d' ' -f6 | grep -E '^.+$')
MONITOR="${monitors[0]}" polybar primary &
for monitor in "${monitors[@]:1}"; do
	MONITOR="$monitor" polybar secondary &
done
