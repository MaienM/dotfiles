#!/usr/bin/env sh

# Make sure asdf is available.
asdf_guard() {
	# shellcheck source=../../../local/bin/commands_require
	. commands_require; commands_require asdf
}

# Ensure the latest version of an asdf plugin is installed.
# Usage: plugin
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

# Find the latest available version (optionally matching a filter) of an asdf install and store it in $version.
# Usage: plugin [filter]
asdf_find_latest_version() {
	plugin="$1"
	filter="^\s*[0-9.]\+\s*$"
	filter="${2:-$filter}"

	asdf_guard
	version="$(asdf list-all "$plugin" | grep "$filter" | tail -n1 | tr -d ' ')"
	if [ -z "$version" ]; then
		echo >&2 "Unable to find latest version for plugin $plugin matching '$filter'."
		exit 1
	fi
}

# As asdf_find_latest_version, but also installs the found version.
# Usage: plugin [filter]
asdf_install_latest_version() {
	plugin="$1"
	asdf_find_latest_version "$@"
	asdf install "$plugin" "$version"
}

# Remove a specific install if it exists.
# Usage: plugin version
asdf_remove() {
	asdf_guard
	if asdf list "$1" 2> /dev/null | grep -q "^\s*$2\s*$"; then
		asdf uninstall "$1" "$2"
	fi
}

# Create an executable in ~/.local/bin that executes the given command in the given install.
# Usage: plugin version command
asdf_link_command() {
	bin="$HOME/.local/bin/$3"
	echo "Creating '$bin'."
	(
		printf '#!/usr/bin/env sh\n'
		printf 'exec %q %q %q %q "$@"\n' "$HOME/.local/bin/run-in-asdf" "$1" "$2" "$3"
	) > "$bin"
	chmod +x "$bin"
}
