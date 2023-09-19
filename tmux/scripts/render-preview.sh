#!/usr/bin/env bash

declare -A PREVIEW_SYMBOLS
PREVIEW_SYMBOLS=(
	[left_border]='│'
	[middle_border]='│'
	[right_border]='│'

	[top_border]='─'
	[top_tsplit]='┬'
	[topleft_corner]='┌'
	[topright_corner]='┐'

	[bottom_border]='─'
	[bottom_tsplit]='┴'
	[bottomleft_corner]='└'
	[bottomright_corner]='┘'

	[title_start]="─${color_fg_blue}╢${color_reset}${color_bg_blue}${color_fg_black} "
	[title_end]=" ${color_reset}${color_fg_blue}╟${color_reset}─"
)

PREVIEW_COLUMNS="${FZF_PREVIEW_COLUMNS:-${COLUMNS:-$(tput cols)}}"
PREVIEW_LINES="${FZF_PREVIEW_LINES:-${LINES:-$(tput lines)}}"

if [ -n "$FZF_PREVIEW_LINES" ]; then
	# fzf is present, so there already is a border, so only draw titles at the top.
	PREVIEW_SYMBOLS[left_border]=
	PREVIEW_SYMBOLS[right_border]=
	PREVIEW_SYMBOLS[topleft_corner]=
	PREVIEW_SYMBOLS[topright_corner]=
	PREVIEW_SYMBOLS[bottomleft_corner]=
	PREVIEW_SYMBOLS[bottomright_corner]=
	PREVIEW_SYMBOLS[bottom_border]=
	PREVIEW_SYMBOLS[bottom_tsplit]=
fi

# shellcheck source=render-preview-inner.sh
source ~/.tmux/scripts/render-preview-inner.sh "$@"
