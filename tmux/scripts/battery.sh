#!/bin/bash

source ~/.tmux/bundle/battery/scripts/helpers.sh

# Get the battery status
_status="$(battery_status 2>&1)"
[[ $_status =~ (attached) ]] && status='A'
[[ $_status =~ (charging) ]] && status='C'
[[ $_status =~ (discharging) ]] && status='D'
[[ $_status =~ (charged) ]] && status='F'
[[ -z $status ]] && exit 0

# Print the icon
[ $status == 'A' ] && echo -n "!▼"
[ $status == 'D' ] && echo -n "▼"
[ $status == 'C' ] && echo -n "▲"
# Print the percentage
echo -n "$(~/.tmux/bundle/battery/scripts/battery_percentage.sh)"
