# Stop if tmux is not available, we're in a session nested in something, or we're not connected through SSH
if (
	[ ! $+commands[tmux] ] ||
	[ -n "$TMUX" ] ||
	[ -n "$EMACS" ] || 
	[ -n "$VIM" ] ||
	[ -n "$INSIDE_EMACS" ]
	[ -z "$SSH_TTY" ]
); then
	return 1
fi

# Start the tmux server if needed
tmux start-server

# Create a base session if there are no sessions
if ! tmux has-session 2> /dev/null; then
	tmux new-session -d -s "base" &> /dev/null
	tmux set-option -t "base" destroy-unattached off &> /dev/null
fi

# Attach to the last session used (which will be the newly created session if none existed previously)
exec tmux attach-session
