#!/usr/bin/env sh

# shellcheck source=./nordvpn-query.sh
. ~/.config/polybar/scripts/nordvpn-query.sh

if [ $connected = 1 ]; then
	nordvpn c "$city"
else
	nordvpn c
fi
