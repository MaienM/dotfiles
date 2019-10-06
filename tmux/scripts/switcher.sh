#!/usr/bin/env sh

switcher_window_name='__switcher_window__'

item="$1"
command="${2:-tmux switch-client -t %%}"
prompt="$prompt"
prefix="$prefix"

case "$item" in
	sessions)
		choose_tree_flag="-s"
		visible_format="$prefix#S (#{session_windows} windows)"
		list_command="list-sessions -F '#S $visible_format'"
		child_command='list-windows -F "#S:#I #S:#I :: #W"'
	;;

	windows)
		choose_tree_flag="-w"
		visible_format="$prefix#S:#I :: #W (#{window_panes} panes)"
		list_command="list-windows -a -F '#S:#I $visible_format'"
		child_command='list-panes -F "#S:#I.#P #S:#I.#P :: #W :: #T"'
	;;

	panes)
		choose_tree_flag=
		visible_format="$prefix#S:#I.#P :: #W :: #T"
		list_command="list-panes -a -F '#S:#I.#P $visible_format'"
		child_command='display-message -p -F "#S:#I.#P #S:#I.#P :: #W :: #T"'
	;;

	*)
		[ -n "$item" ] && echo >&2 "Unknown type '$item'."
		echo >&2 'Please pass a valid type to switch between. Options: sessions, windows, panes.'
		exit 1
	;;
esac

if command -v fzf > /dev/null 2>&1; then
	tmux new-window -n "$switcher_window_name" -t :999 -k "
		tmux $list_command \
		| grep -v '$switcher_window_name' \
		| fzf \
			--reverse \
			--with-nth=2.. \
			${prompt:+--prompt=\"$prompt\"} \
			--preview-window='down:65%' \
			--preview='
				tmux $child_command -t {1} \
				| grep -v \"$switcher_window_name\" \
				| xargs -d\"\\n\" $HOME/.tmux/scripts/render-preview.sh \
			' \
		| cut -d' ' -f1 \
		| xargs -r -I '%%' $command
	"
else
	tmux choose-tree -Z "$choose_tree_flag" -F "$visible_format" "$command"
fi

