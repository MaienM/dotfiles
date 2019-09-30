#!/usr/bin/env sh

switcher_window_name='__switcher_window__'

case "$1" in
	sessions)
		choose_tree_flag="-s"
		list_command='list-sessions -F "#S #S (#{session_windows} windows)"'
		child_command='list-windows -F "#S:#I #S:#W"'
	;;

	windows)
		choose_tree_flag="-w"
		list_command='list-windows -a -F "#S:#I #S: #W (#{window_panes} panes)"'
		child_command='list-panes -F "#S:#I.#P #S:#W.#P"'
	;;

	panes)
		choose_tree_flag=
		list_command='list-panes -a -F "#S:#I.#P #S: #W: #P (#T)"'
		child_command='display-message -p -F "#S:#I.#P #S:#W.#P"'
	;;

	*)
		[ -n "$1" ] && echo >&2 "Unknown type '$1'."
		echo >&2 'Please pass a valid type to switch between. Options: sessions, windows, panes.'
		exit 1
	;;
esac

if command -v fzf > /dev/null 2>&1; then
	tmux new-window -n "$switcher_window_name" "
		tmux $list_command \
		| grep -v '$switcher_window_name' \
		| fzf \
			--reverse \
			--with-nth=2.. \
			--preview-window='down:65%' \
			--preview='
				tmux $child_command -t {1} \
				| grep -v \"$switcher_window_name\" \
				| xargs -d\"\\n\" $HOME/.tmux/scripts/render-preview.sh \
			' \
		| cut -d' ' -f1 \
		| xargs -r tmux switch-client -t
	"
else
	tmux choose-tree -Z "$choose_tree_flag"
fi

