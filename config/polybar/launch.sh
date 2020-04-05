#!/usr/bin/env bash

. commands_require; commands_require polybar 2> /dev/null || exit 0

# Terminate already running bar instances
killall -q polybar

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

# Launch bars for all screens
mapfile -t monitors < <(xrandr --listmonitors | cut -d' ' -f6 | grep -E '^.+$')
MONITOR="${monitors[0]}" polybar primary &
for monitor in "${monitors[@]:1}"; do
	MONITOR="$monitor" polybar secondary &
done
