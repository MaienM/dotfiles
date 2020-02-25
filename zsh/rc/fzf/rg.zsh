if ! command -v rg &> /dev/null; then
	return
fi

zmodload zsh/mapfile

# General source to preview rg search results.

local rg_jq_transform="$(echo '
	map(
		select(.type == "match") |
		.data |
		(
			. as $full |
			.submatches |
			map({
				line: $full.line_number,
				start: .start,
				end: .end,
				text: .match.text,
			}) |
			map([.line, ":", .start, ":", .end, "::", .text] | map(tostring) | add)
		)
	) | flatten | .[]
	' | tr -d '\n' | sed 's/\s\+/ /g')"

_fzf_pipeline_rg_file_source() {
	file="$1"
	lines=("${(@f)mapfile[$file]}")
	rg "${@:2}" --json < "$file" \
	| jq -sr "$rg_jq_transform" \
	| while read -r line; do
		echo "${(q)file}:${(q)line} ${line#*::}"
	done \
	| tac
}

_fzf_pipeline_rg_file_preview() {
	setopt local_options multibyte
	unsetopt multibyte

	source ~/.functions/strip_escape
	source ~/.functions/substring_escape

	real_width() {
		printf '%s' "$1" | strip_escape | wc -m
	}

	input="${(Q)1}"
	parts=("${(s.:.)input}")
	file="${parts[1]}"
	line_num="${parts[2]}"
	col1="${parts[3]}"
	col2="${parts[4]}"

	lines=("${(@f)mapfile[$file]}")
	full_line="${lines[$line_num]}"
	contents_prefix="${full_line:0:$col1}"
	contents="${full_line:$col1:$((col2 - col1))}"
	contents_suffix="${full_line:$col2}"
	# Should be $color_standout_reset instead of $color_reset, but due to a bug in fzf this doesn't work. This has
	# been fixed, so this can be changed once a new version is released.
	colored_line="$contents_prefix$color_standout$contents$color_reset$contents_suffix"

	# Try to get the highlighted portion on the screen.
	skipchars=0
	if [ "$(real_width "$contents")" -ge "$FZF_PREVIEW_COLUMNS" ]; then
		# Contents are too large to fit, so just start the line at the start of the highlight.
		skipchars="$(real_width "$contents_prefix")"
	elif [ "$(real_width "$contents_prefix$contents")" -gt "$FZF_PREVIEW_COLUMNS" ]; then
		# The end of the content won't fit, so we need to skip some at the start of each line.
		skipchars=$(($(real_width "$contents_prefix$contents") - FZF_PREVIEW_COLUMNS))
	fi

	(
		head -n$((line_num - 1)) < "$file" | tail -n$((FZF_PREVIEW_LINES / 2))
		printf '%s\n' "$colored_line"
		tail -n+$((line_num + 1)) < "$file" | head -n$(((FZF_PREVIEW_LINES - 1) / 2))
	) | substring_escape "$skipchars" "$FZF_PREVIEW_COLUMNS"
}

_fzf_pipeline_rg_file_target() {
	echo "${${(Q)1}#*::}"
}

