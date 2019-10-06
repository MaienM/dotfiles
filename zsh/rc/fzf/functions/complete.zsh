# Run a command, and use the results for completion.
#
# The first argument is the command to run.
#
# The rest of the arguments are what the result should be prefixed with before it is set as LBUFFER. When called from an
# _fzf_complete_* function, this is "$@".
_fzf_run_as_complete() {
	local results

	if [[ $# -lt 1 ]]; then
		echo "Not enough arguments" >&2
		return 1
	fi

	# Run the command
	$(resolve_alias $1) | read -r results || return 1
	shift 1

	# Add the results to the buffer
	if [[ -n "$results" ]]; then
		LBUFFER="$@$results"
	fi
}
