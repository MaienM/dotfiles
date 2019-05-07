#!/usr/bin/env sh

set -e

clone() {
	[ -d "$2" ] || git clone "$1" "$2"
}

clone https://github.com/jenv/jenv ~/.jenv
