function twitch() {
	channel="$1"
	if [ -z "$channel" ]; then
		channel="$(
			twitchnotifier -c MaienM -n \
			| sed "s/^\\([^:]*\\):\\(.*\\):\\([0-9]*\\)$/\\1 $color_fg_cyan\\1$color_reset playing $color_fg_blue\\2$color_reset for $color_fg_green\\3 viewer(s)$color_reset/" \
			| fzf --with-nth=2.. --ansi \
			| cut -d' ' -f1
		)"
		if [ -z "$channel" ]; then
			return
		fi
	fi

	if command -v chatterino > /dev/null; then
		chatterino -c "$channel" &
	else
		xdg-open "https://twitch.tv/$1/chat/popout"
	fi
	streamlink "twitch.tv/$channel" best
}

function twitch-vods() {
	channel="$1"
	if [ -z "$channel" ]; then
		channel="$(twitchnotifier -c MaienM -f | fzf)"
		if [ -z "$channel" ]; then
			return
		fi
	fi

	# Start the chat program, but only if it's not already running - it should pick up changes automatically if it is.
	# if [ ! "$(tmux list-pane -F '#{pane_current_command}' -t scratch:2)" = "python" ] \
	# 	|| [[ ! "$(tmux capture-pane -p -t scratch:2.1 | tail -n1)" == "Video time:"* ]];
	# then
		# Not actually true yet, so always restart for now.
		tmux new-window -t scratch:2 -k -c "$HOME/coding/projects/mpv-utils"
		tmux send-keys -t scratch:2 $'sleep 10; python src/mpv-utils\n'
	# fi

	mpv --ytdl-raw-options=playlist-reverse= "https://www.twitch.tv/$channel/videos/past-broadcasts"
}

