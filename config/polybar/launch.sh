#!/usr/bin/env bash

# Terminate already running bar instances
killall -q polybar

# Wait until the processes have been shut down
while pgrep -u $UID -x polybar >/dev/null; do sleep 1; done

# Setup environment variables for icons
export fa_bolt=$(echo -ne "\uF0E7")
export fa_calendar=$(echo -ne "\uF133")
export fa_clock=$(echo -ne "\uF017")
export fa_hdd=$(echo -ne "\uF0A0")
export fa_memory=$(echo -ne "\uF538")
export fa_plug=$(echo -ne "\uF1E6")
export fa_power_off=$(echo -ne "\uF011")
export fa_server=$(echo -ne "\uF233")
export fa_sun=$(echo -ne "\uF185")
export fa_wifi=$(echo -ne "\uF1EB")
export fa_ban=$(echo -ne "\uF05E")
export fa_times=$(echo -ne "\uF00D")
export fa_redo=$(echo -ne "\uF01E")
export fa_bed=$(echo -ne "\uF236")

export fa_battery_empty=$(echo -ne "\uF244")
export fa_battery_quarter=$(echo -ne "\uF243")
export fa_battery_half=$(echo -ne "\uF242")
export fa_battery_three_quarters=$(echo -ne "\uF241")
export fa_battery_full=$(echo -ne "\uF240")

export fa_thermometer_empty=$(echo -ne "\uF2CB")
export fa_thermometer_quarter=$(echo -ne "\uF2CA")
export fa_thermometer_half=$(echo -ne "\uF2C9")
export fa_thermometer_three_quarters=$(echo -ne "\uF2C8")
export fa_thermometer_full=$(echo -ne "\uF2C7")

export fa_volume_off=$(echo -ne "\uF026")
export fa_volume_down=$(echo -ne "\uF027")
export fa_volume_up=$(echo -ne "\uF028")

# Launch bars for all screens
monitors=($(xrandr --listmonitors | cut -d' ' -f6))
MONITOR="${monitors[0]}" polybar primary &
for monitor in ${monitors[@]:1}; do
	MONITOR="$monitor" polybar secondary &
done
