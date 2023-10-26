# Get the definition of an alias
resolve_alias() {
	local name

	name=$1
	if [ -n "${aliases[$name]}" ]; then
		shift 1
		resolve_alias ${aliases[$name]} "$@"
	else
		echo "$@"
	fi
}

# Run an alias with sudo
sudoa() {
	sudo zsh -c "exec $(printf '%q ' $(resolve_alias "$@"))"
}

# Run a function with sudo
sudof() {
	sudo zsh -c "$(declare -f "$1"); exec $(printf '%q ' "$@")"
}
