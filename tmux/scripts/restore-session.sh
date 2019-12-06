#!/usr/bin/env bash

set -e

mapfile -t -d '' jq_preview_query <<END
	def item(namef): (if .focus? then "*" else "" end) + namef;

	.windows
	| map(
		item(.window_name),
		(.panes | map(item(.shell_command? // .)) | map(" - "+ .))
	)
	| flatten
	| join("\\n") 
END

dir="$HOME/.tmux/frozen"
mkdir -p "$dir"
file="$(
	find "$dir" -type f -printf '%p\0' \
	| while IFS= read -r -d '' fn; do
		mapfile -t counts < <(jq '(.windows | length), (.windows | map(.panes) | flatten | length)' < "$fn")
		printf '%s %s (%d windows, %d panes)\0' "$fn" "$(basename "$fn")" "${counts[0]}" "${counts[1]}"
	done \
	| fzf \
		--read0 \
		--reverse \
		--with-nth=2.. \
		--prompt="(restore-session) " \
		--preview-window='down:65%' \
		--preview="jq -r '${jq_preview_query[0]}' {1}" \
	| cut -d' ' -f1
)"

if [ -f "$file" ]; then
	tmuxp load "$file"
fi
