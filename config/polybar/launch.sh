#!/usr/bin/env bash

# Terminate already running bar instances
killall -q polybar

# Wait until the processes have been shut down
while pgrep -u $UID -x polybar >/dev/null; do sleep 1; done

# Load the icons
set -a
source nerdfonts_icons_all
set +a

# Make the colors available as environment variables
eval "$(xrdb -query | grep '^*color' | while read -r line; do
	name="$(echo "$line" | cut -c2- | cut -d: -f1)"
	color="$(echo "$line" | cut -d: -f2 | tr -d '[:space:]')"
	echo export "$name='$color'"
done)"

# Launch bars for all screens
mapfile -t monitors < <(xrandr --listmonitors | cut -d' ' -f6 | grep -E '^.+$')
MONITOR="${monitors[0]}" polybar primary &
for monitor in "${monitors[@]:1}"; do
	MONITOR="$monitor" polybar secondary &
done
