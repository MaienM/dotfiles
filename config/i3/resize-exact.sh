#!/usr/bin/env bash

set -o errexit -o pipefail

# shellcheck disable=SC1090
. ~/.config/i3/_utils.sh

if [ -z "$*" ]; then
	echo >&2 "Usage: $0 width height"
	exit 1
fi

width="$1"
height="$2"
if [ ! "$width" -ge 0 ] || [ ! "$height" -ge 0 ]; then
	echo >&2 "Width ($width) and height ($height) must be positive integers, or zero to not change in that dimension."
	exit 1
fi
if [ "$width" -eq 0 ] && [ "$height" -eq 0 ]; then
	echo >&2 "Width and height cannot both be zero."
	exit 1
fi

i3-msg "resize set width $width height $height"

# Check whether the actual size is what was requested. If not, adjust by the amount that the size is off by and try
# again. Eg, a height of 500 was requested, but the actual resuling size is 490, so now request a height of 510.
mapfile -t actual_size < <(get_active_window_info | jq ".rect.width, .rect.height")
if [ "$width" -gt 0 ] && [ "$width" -ne "${actual_size[0]}" ]; then
	corrected_width=$((width * 2 - actual_size[0]))
fi
if [ "$height" -gt 0 ] && [ "$height" -ne "${actual_size[1]}" ]; then
	corrected_height=$((height * 2 - actual_size[1]))
fi
if [ -n "$corrected_width" ] || [ -n "$corrected_height" ]; then
	i3-msg "resize set width $((corrected_width)) height $((corrected_height))"
fi

