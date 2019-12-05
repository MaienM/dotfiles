source ~/.zsh/bundle/powerlevel10k/config/p10k-lean.zsh

# Segments.
POWERLEVEL9K_LEFT_PROMPT_ELEMENTS=(
	dir
	vcs
	newline

	prompt_char
)
POWERLEVEL9K_RIGHT_PROMPT_ELEMENTS=(
	status
	command_execution_time
	root_indicator
	background_jobs
	context_custom
	time
)

# Modify the colors, as the default ones don't work well with a light theme.
POWERLEVEL9K_DIR_ANCHOR_FOREGROUND=33
POWERLEVEL9K_VCS_CONTENT_EXPANSION="${POWERLEVEL9K_VCS_CONTENT_EXPANSION//\%28F/%22F}"
POWERLEVEL9K_VCS_CONTENT_EXPANSION="${POWERLEVEL9K_VCS_CONTENT_EXPANSION//\%39F/%33F}"
POWERLEVEL9K_VCS_CONTENT_EXPANSION="${POWERLEVEL9K_VCS_CONTENT_EXPANSION//\%76F/%64F}"
POWERLEVEL9K_VCS_CONTENT_EXPANSION="${POWERLEVEL9K_VCS_CONTENT_EXPANSION//\%178F/%166F}"

# Make the time actually useful by making it the start time of the command.
POWERLEVEL9K_TIME_UPDATE_ON_COMMAND=true

# Show exit code of last command if non-successful. Shorten the signal names.
POWERLEVEL9K_STATUS_ERROR_CONTENT_EXPANSION='${P9K_CONTENT//SIG}'

# I have multiple names for my default accounts.
# Figure out which exist on this system.
possible=(michon maienm)
existing=()
for user in ${possible[@]}; do
	if id -u $user &> /dev/null; then
		existing+=($user)
	fi
done
# If only a single of these user accounts exists on this machine, set it as the default user.
# If multiple exist, don't set the default user at all so it will always be visible who I currently am.
if [ ${#existing} -eq 1 ]; then
	DEFAULT_USER=${existing[1]}
fi

prompt_context_custom() {
	# The tmux statusline already includes the hostname, so don't make SSH show the context when in tmux.
	if [[ -n "$TMUX" ]]; then
		SSH_CLIENT= SSH_TTY= POWERLEVEL9K_CONTEXT_TEMPLATE="%n" prompt_context "$@"
	else
		prompt_context "$@"
	fi
}
