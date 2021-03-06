#!/usr/bin/env sh

asdf_guard() {
	# shellcheck source=../../../local/bin/commands_require
	. commands_require; commands_require asdf
}

asdf_plugin_add() {
	asdf_guard
	for plugin in "$@"; do
		if [ -e "$HOME/.asdf/plugins/$plugin" ]; then
			asdf plugin-update "$plugin"
		else
			asdf plugin-add "$plugin"
		fi
		case "$plugin" in
			nodejs) ~/.asdf/plugins/nodejs/bin/import-release-team-keyring ;;
		esac
	done
}

asdf_find_latest_version() {
	plugin="$1"
	filter="${2:-^\s*[0-9.]\+\s*$}"

	asdf_guard
	version="$(asdf list-all "$plugin" | grep "$filter" | tail -n1 | tr -d ' ')"
	if [ -z "$version" ]; then
		echo >&2 "Unable to find latest version for plugin $plugin matching '$filter'."
		exit 1
	fi
}

asdf_install_latest_version() {
	plugin="$1"
	asdf_find_latest_version "$@"
	asdf install "$plugin" "$version"
}

asdf_remove() {
	asdf_guard
	if asdf list "$1" 2> /dev/null | grep -q "^\s*$1\s*$"; then
		asdf uninstall "$1" "$2"
	fi
}
