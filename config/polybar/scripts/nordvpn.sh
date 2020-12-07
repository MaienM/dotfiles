#!/usr/bin/env bash

status_pattern="\
Status: Connected
Current server: .*
Country: (.*)
City: (.*)
Your new IP: .*
Transfer: .*
Uptime: .*\
"

if ! [[ "$(nordvpn status)" =~ $status_pattern ]]; then
	echo "Off"
	exit 0
fi

country="${BASH_REMATCH[1]}"
city="${BASH_REMATCH[2]}"

echo "$country/$city"
