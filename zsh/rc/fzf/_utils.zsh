_fzf_require_sudo() {
	# When in preview, just fail silently
	if [ -n "$FZF_PREVIEW_LINES" ]; then
		echo "This pipeline requires sudo and is not suitable for preview" | fold >&2 -s -w"$FZF_PREVIEW_COLUMNS"
		exit 1;
	fi

	sudo "$@"
}
