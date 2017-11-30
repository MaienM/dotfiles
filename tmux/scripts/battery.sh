#!/bin/bash

source ~/.tmux/bundle/battery/scripts/helpers.sh

# Get the battery status
status="$(battery_status)"
[[ $status =~ (attached) ]] && status='A'
[[ $status =~ (discharging) ]] && status='D'
[[ $status =~ (charging) ]] && status='C'
[[ $status =~ (charged) ]] && status='F'

# Print the icon
[ $status == 'A' ] && echo -n "!▼"
[ $status == 'D' ] && echo -n "▼"
[ $status == 'C' ] && echo -n "▲"
# Print the percentage
echo -n "$(~/.tmux/bundle/battery/scripts/battery_percentage.sh)"
