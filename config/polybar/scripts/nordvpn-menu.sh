#!/usr/bin/env bash

mapfile -t entries < <(
	list() {
		# The first 3 lines are '', '-', '-' for some reason, so skip them.
		nordvpn "$@" | tr -s '[:space:]' '\n' | tr -d ',' | tail -n+4
	}

	declare -A entries
	add() {
		if [ -n "${entries[$1]}" ]; then
			return
		fi
		entries[$1]=1
		echo "c $1|$2"
	}

	# shellcheck source=./nordvpn-query.sh
	. ~/.config/polybar/scripts/nordvpn-query.sh

	if [ $connected = 1 ]; then
		echo 'd|Disconnect'
	fi
	echo 'c|Automatic'

	# Groups. These don't change often and their names aren't what I'd like them to be in the list, so this is hardcoded.
	add 'Europe' 'Europe'
	add 'The_Americas' 'The Americas'
	add 'Asia_Pacific' 'Asia, Pacific Region'
	add 'Africa_The_Middle_East_And_India' 'Africa, Middle East, India'
	add 'P2P' 'Servers with P2P Support'

	# Cities within the current country.
	if [ -n "$country" ] && nordvpn cities "$country" > /dev/null 2>&1; then
		list cities "$country" | sort | while read -r entry; do
			add "$entry" "$country: $entry"
		done
	fi

	# Countries. Some common picks first and then a full list of all the others.
	add 'United_States' 'USA'
	list countries | sort | while read -r entry; do
		name="${entry//_/ }"
		name="${name//And/and}"
		add "$entry" "$name"
	done
)

subcommand="$(printf '%s\n' "${entries[@]}" | rofi-dmenu-with-key -i)"
if [ -n "$subcommand" ]; then
	# shellcheck disable=2086
	nordvpn $subcommand
fi
