#!/usr/bin/env bash

repeat() {
	count=$1
	while [ "$count" -gt 0 ]; do
		echo "$2"
		count=$((count - 1))
	done
}

mapfile -t messages < <(
	repeat 100 'YubiKey waiting for touch'

	# Satisfaction - Benny Benassi
	echo 'Push me and then just touch me'
	# U Can't Touch This - MC Hammer
	echo "You can't touch this"
	# Baby One More Time - Britney Spears
	echo 'Hit me baby one more time'
	# Barbie Girl - Aqua
	echo 'You can touch, you can play'
	# Technologic - Daft Punk
	echo 'Touch it, bring it, pay it, watch it, turn it, leave it, stop, format it'
)

socat - "UNIX-CONNECT:$XDG_RUNTIME_DIR/yubikey-touch-detector.socket" \
	| while read -r -n5 message; do
		case "$message" in
			*_1)
				echo "${messages[RANDOM % ${#messages[@]}]}"
				;;
			*)
				echo
				;;
		esac
	done
