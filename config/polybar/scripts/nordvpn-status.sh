#!/usr/bin/env bash

# shellcheck source=./nordvpn-query.sh
. ~/.config/polybar/scripts/nordvpn-query.sh

[ $connected = 1 ] && echo "$country/$city" || echo "Off"
