#!/usr/bin/env bash

status_pattern="\
Status: Connected
Current server: .*
Country: (.*)
City: (.*)
Server IP: .*"

if ! [[ "$(nordvpn status)" =~ $status_pattern ]]; then
	export connected=0
	return
fi

export connected=1
export country="${BASH_REMATCH[1]}"
export city="${BASH_REMATCH[2]}"
