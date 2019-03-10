#!/usr/bin/env bash

set -o errexit -o pipefail
shopt -s extglob

# shellcheck disable=SC1090
. ~/.config/i3/_utils.sh

if [ -z "$*" ]; then
	echo >&2 "Usage: $0 ratio dimension"
	echo >&2 "Example: $0 16:9 width will change the width to get the window (close to) a 16:9 ratio"
	exit 1
fi

ratio="$1"
case "$ratio" in
	+([0-9]):+([0-9]))
		ratio1=${ratio%:*}
		ratio2=${ratio#*:}

		if [ "$ratio1" -le 0 ] || [ "$ratio2" -le 0 ]; then
			echo >&2 "Cannot have a negative or zero in the ratio"
			exit 1
		fi
	;;

	*)
		echo >&2 "Invalid value ($ratio) for the ratio set, must be in the form of width:height (eg 4:3, 16:9)"
		exit 1
	;;
esac

target="$2"
case "$target" in
	'width') calc="height * $ratio1 / $ratio2 - 2" ;;
	'height') calc="width / $ratio1 * $ratio2 + 1" ;;
	*)
		echo >&2 "Invalid value ($target) for the dimension to set, must be either 'width' or 'height'"
		exit 1
	;;
esac

# Use jq to calculate the desired target size from the client info.
target_size="$(get_active_window_info | jq ".rect.$calc | nearbyint")"
i3-msg "resize set $target $target_size px"

# Check whether the actual size is what was requested. If not, adjust by the amount that the size is off by and try
# again. Eg, a height of 500 was requested, but the actual resuling size is 490, so now request a height of 510.
actual_size="$(get_active_window_info | jq ".rect.$target")"
if [ "$target_size" -ne "$actual_size" ]; then
	i3-msg "resize set $target $((target_size * 2 - actual_size))"
fi

