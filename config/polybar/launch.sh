#!/usr/bin/env bash

. commands_require
commands_require polybar 2> /dev/null || exit 0

# Terminate already running bar instances
pkill -f bin/polybar

# Wait until the processes have been shut down
while pgrep -u $UID -x polybar > /dev/null; do sleep 1; done

# Get the names of the available physical network interfaces.
mapfile -t eths < <(find /sys/class/net -type l -not -lname '*virtual*' -not -name 'w*' -printf '%f\n')
mapfile -t wlans < <(find /sys/class/net -type l -not -lname '*virtual*' -name 'w*' -printf '%f\n')
for i in {0..2}; do
	declare -x "eth$i=${eths[i]}"
	declare -x "wlan$i=${wlans[i]}"
done

# Launch bars for all screens
mkdir -p ~/.log
mapfile -t monitors < <(xrandr --listmonitors | cut -d' ' -f6 | grep -E '^.+$')
MONITOR="${monitors[0]}" polybar --log=info --reload primary > ~/.log/polybar 2>&1 &
for monitor in "${monitors[@]:1}"; do
	MONITOR="$monitor" polybar -q --reload secondary &
done
