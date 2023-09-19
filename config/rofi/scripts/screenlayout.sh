#!/usr/bin/env bash
# shellcheck disable=SC2154

# Switch between screen layouts defined in ~/.config/screenlayouts.
# Each .sh file in this folder is shown as a layout.
# Each script should contain two comments in the following form:
#
# icon -> icon_name
# description -> The description of the screen layout.

set -e

# shellcheck source=../../../local/bin/commands_require
. commands_require
commands_require rofi

args=()
for script in ~/.config/screenlayouts/*.sh; do
	icon="$(grep '^#\s*icon:.*$' "$script" | head -n1 | sed 's/^#\s*icon:\s*//; s/\s*(.*)$//')"
	description="$(grep '^#\s*description:.*$' "$script" | head -n1 | sed 's/^#\s*description:\s*//')"
	if [ -z "$icon" ] || [ -z "$description" ]; then
		echo >&2 "$script is missing the required comments, ignoring."
		continue
	fi
	args=("${args[@]}" "$script $icon $description")
done

choice="$(~/.config/rofi/scripts/iconmenu.sh "${args[@]}")" || exit 0
sh "$choice"
sleep 2
~/.config/polybar/launch.sh
set-background
