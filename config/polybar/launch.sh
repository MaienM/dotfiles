#!/usr/bin/env bash

# Terminate already running bar instances
killall -q polybar

# Wait until the processes have been shut down
while pgrep -u $UID -x polybar >/dev/null; do sleep 1; done

# Load the icons
set -a
source nerdfonts_icons_all
set +a

# Launch bars for all screens
mapfile -t monitors < <(xrandr --listmonitors | cut -d' ' -f6 | grep -E '^.+$')
MONITOR="${monitors[0]}" polybar primary &
for monitor in "${monitors[@]:1}"; do
	MONITOR="$monitor" polybar secondary &
done
