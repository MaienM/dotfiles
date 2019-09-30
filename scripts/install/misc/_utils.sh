#!/usr/bin/env sh

find_latest_asdf_version() {
	plugin="$1"
	filter="$2"

	asdf list-all "$plugin" | grep "$filter" | tail -n1 | tr -d ' '
}

remove_asdf_virtualenv() {
	if asdf list python-venv 2> /dev/null | grep -q "^\s*$1\s*$"; then
		asdf uninstall python-venv "$1"
	fi
}

