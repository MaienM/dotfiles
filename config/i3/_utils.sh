#!/usr/bin/env sh

get_active_window_info() {
	i3-msg -t 'get_tree' | jq 'until(isempty(.focus[]); . as $root | .nodes[] | select(.id == $root.focus[0]))'
}
