#!/usr/bin/env sh

clone() {
	[ -d "$2" ] || git clone "$1" "$2"
}

clone https://github.com/jenv/jenv ~/.jenv
