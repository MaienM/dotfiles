#!/usr/bin/env bash

# Renders a preview of one or more panes, like in tmux's choose-tree command.

# The PREVIEW_SYMBOLS used to draw the visuals in/around the preview.
# These are allowed to contain escape characters, and everything except for the top_border, bottom_border and
# title_border are allowed to be multi-character.
declare -A PREVIEW_SYMBOLS

: "${PREVIEW_SYMBOLS[left_border]=|}"
: "${PREVIEW_SYMBOLS[middle_border]=|}"
: "${PREVIEW_SYMBOLS[right_border]=|}"

: "${PREVIEW_SYMBOLS[top_border]=-}"
: "${PREVIEW_SYMBOLS[top_tsplit]=+}"
: "${PREVIEW_SYMBOLS[topleft_corner]=+}"
: "${PREVIEW_SYMBOLS[topright_corner]=+}"

: "${PREVIEW_SYMBOLS[bottom_border]=-}"
: "${PREVIEW_SYMBOLS[bottom_tsplit]=+}"
: "${PREVIEW_SYMBOLS[bottomleft_corner]=+}"
: "${PREVIEW_SYMBOLS[bottomright_corner]=+}"

: "${PREVIEW_SYMBOLS[title_start]="-[ "}"
: "${PREVIEW_SYMBOLS[title_end]=" ]-"}"

: "${PREVIEW_SYMBOLS[title_border]=}"
: "${PREVIEW_SYMBOLS[title_left_corner]=}"
: "${PREVIEW_SYMBOLS[title_right_corner]=}"


# shellcheck source=../../functions/substring_escape
source ~/.functions/substring_escape

# Get the visible contents for a given pane, including escape codes.
# printf '%s\n' "$output" will result in (mostly) identical output.
capture_pane() {
	tmux capture-pane -t "$1" -pe 
}

# Calculate the widths of the previews for a given width and amount of items to preview. Takes symbol[left_border],
# symbol[middle_border] and symbol[right_border] into account.
# Usage: width number_of_previews
calculate_widths() {
	local width items maxsize itemsatmaxsize i size

	width="$1"
	items="$2"

	# Account for the borders
	width=$((width - ((items - 1) * swidths[middle_border]) - swidths[left_border] - swidths[right_border]))
	# Determine the width of the widest item(s).
	maxsize=$(((width + items - 1) / items))
	# Determine how many items can have this width before we have to step to a lower width.
	itemsatmaxsize=$((width - (maxsize - 1) * items))

	i=0;
	size="$maxsize"
	for ((i=0; i<$(($2)); i++)); do
		printf '%s\n' "$size"
		if [ "$i" -eq "$itemsatmaxsize" ]; then
			size=$((size - 1))
		fi
	done
}

# Repeat a character the given amount of times.
repeat_char() {
	local i
	for ((i=0; i<=$(($1)); i++)); do
		printf '%s' "$2"
	done
}

# Preserve exactly n lines from the end of the input (like tail -n). If less lines are given than n, add empty lines at
# the bottom (unline tail -n).
tail_or_pad() {
	awk -v"n=$1" '1; END { for (i=NR;i<n;i++) print "" }' | tail -n "$1"
}

# Cut each line from the input to be exactly n visible characters long (handles escape codes, unlike cut). Adds spaces
# (or a user provided character) to the end if lines are too short.
cut_or_pad() {
	local padding
	padding="$(repeat_char "$1" "${2:- }")"
	awk -v"p=$padding" '{ print $0 p }' | substring_escape 0 "$1"
}

# Render all previews, with all decoration as defined in PREVIEW_SYMBOLS.
# Usage: width height id [id..]
render_preview() {
	local columns lines ids titles arg argparts width symbol bwidth

	columns="$1"
	lines="$(($2 - 1))"
	[ -n "${PREVIEW_SYMBOLS[bottom_border]}" ] && lines="$((lines - 1))"
	[ -n "${PREVIEW_SYMBOLS[title_border]}" ] && lines="$((lines - 1))"
	shift 2

	# Process arguments into ids & titles.
	ids=()
	titles=()
	for ((i=0; i<$#; i+=1)); do
		arg="$((i + 1))"
		mapfile -t argparts < <(printf '%s' "${!arg}" | tr ' ' $'\n')
		ids[i]="${argparts[0]}"
		titles[i]="${argparts[1]:-${argparts[0]}}"
	done

	# Put all preview lines of all panes in a single array, back to back.
	mapfile -t widths < <(calculate_widths "$columns" $#)
	for ((i=0; i<$#; i+=1)); do
		mapfile -t -O$((i * lines)) previewlines < \
			<(capture_pane "${ids[i]}" | tail_or_pad "${lines}" | cut_or_pad "${widths[i]}")
	done

	# Titles are embeded in a single line.
	symbol="${PREVIEW_SYMBOLS[topleft_corner]}"
	bwidth="${swidths[left_border]}"
	for ((i=0; i<$#; i+=1)); do
		printf '%s%s%s%s' "$symbol" "${PREVIEW_SYMBOLS[title_start]}" "${titles[i]}" "${PREVIEW_SYMBOLS[title_end]}" \
		| cut_or_pad "$((widths[i] + bwidth))" "${PREVIEW_SYMBOLS[top_border]}" \
		| tr -d '\n'
		symbol="${PREVIEW_SYMBOLS[top_tsplit]}"
		bwidth="${swidths[middle_border]}"
	done
	printf '%s\n' "${PREVIEW_SYMBOLS[topright_corner]}"

	# Render the below-title line, if the PREVIEW_SYMBOLS for it are defined.
	if [ -n "${PREVIEW_SYMBOLS[title_border]}" ]; then
		symbol="${PREVIEW_SYMBOLS[left_border]}"
		for ((i=0; i<$#; i+=1)); do
			printf '%s' "$symbol"
			printf '%s%s%s' \
				"${PREVIEW_SYMBOLS[title_left_corner]}" \
				"$(
					repeat_char "$columns" "${PREVIEW_SYMBOLS[title_border]}" \
					| substring_escape 0 "$(printf '%s' "${titles[i]}" | strip_escape | wc -m)"
				)" \
				"${PREVIEW_SYMBOLS[title_right_corner]}" \
			| cut_or_pad "${widths[i]}" \
			| tr -d '\n'
			symbol="${PREVIEW_SYMBOLS[middle_border]}"
		done
		printf '%s\n' "${PREVIEW_SYMBOLS[right_border]}"
	fi

	# Render the actual contents, with separators.
	for ((ln=0; ln<lines; ln+=1)); do
		symbol="${PREVIEW_SYMBOLS[left_border]}"
		for ((i=0; i<$#; i+=1)); do
			# shellcheck disable=SC2154
			printf '%s%s' "$symbol" "${previewlines[i*lines+ln]}$color_reset"
			symbol="${PREVIEW_SYMBOLS[middle_border]}"
		done
		printf '%s\n' "${PREVIEW_SYMBOLS[right_border]}"
	done

	# Render the bottom bar only if a bottom bar symbol is defined.
	if [ -n "${PREVIEW_SYMBOLS[bottom_border]}" ]; then
		symbol="${PREVIEW_SYMBOLS[bottomleft_corner]}"
		bwidth="${swidths[left_border]}"
		for ((i=0; i<$#; i+=1)); do
			printf '%s' "$symbol" | cut_or_pad "$((widths[i] + bwidth))" "${PREVIEW_SYMBOLS[bottom_border]}" | tr -d '\n'
			symbol="${PREVIEW_SYMBOLS[bottom_tsplit]}"
			bwidth="${swidths[middle_border]}"
		done
		printf '%s\n' "${PREVIEW_SYMBOLS[bottomright_corner]}"
	fi
}


# Determine widths of the PREVIEW_SYMBOLS.
declare -A swidths
for key in "${!PREVIEW_SYMBOLS[@]}"; do
	swidths[$key]="$(printf '%s' "${PREVIEW_SYMBOLS[$key]}" | strip_escape | wc -m)"
done

# Validate widths.
assert_width() {
	local width
	for ((i=4; i<=$#; i+=1)); do
		width="${swidths[${!i}]}"
		if [ "$1" -ne "$width" ]; then
			echo >&2 "$assertmessage width of symbol ${!i} ($width) $2."
			exit 1
		fi
	done
}
assert_same() {
	assert_width "${swidths[$1]}" "must be the same as $1 (${swidths[$1]})" "$@"
}
assert_fixed() {
	assert_width "$1" "must be $1" "$@"
}
assertmessage="The"
assert_same left_border topleft_corner
assert_same right_border topright_corner
assert_same middle_border top_tsplit
assert_fixed 1 top_border
if [ "${swidths[bottom_border]}" -ne 0 ]; then
	assertmessage="Because the bottom border is being drawn (bottom_border symbol is not empty), the"
	assert_same left_border bottomleft_corner
	assert_same right_border bottomright_corner
	assert_same middle_border bottom_tsplit
	assert_fixed 1 bottom_border
fi
if [ "${swidths[title_border]}" -ne 0 ]; then
	assertmessage="Because the title border is being drawn (title_border symbol is not empty), the"
	assert_same title_start title_left_corner
	assert_same title_end title_right_corner
	assert_fixed 1 title_border
fi


if [ $# -lt 1 ]; then
	echo >&2 "Must pass at least one tmux session/window/pane identifier."
	exit 1
fi

columns="${PREVIEW_COLUMNS:-${COLUMNS:-$(tput cols)}}"
lines="${PREVIEW_LINES:-${LINES:-$(tput lines)}}"

render_preview "$columns" "$lines" "$@"

