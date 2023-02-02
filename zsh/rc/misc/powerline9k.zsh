source ~/.zsh/bundle/powerlevel10k/config/p10k-lean.zsh

# Segments.
POWERLEVEL9K_LEFT_PROMPT_ELEMENTS=(
	dir
	vcs
	nix_shell_packages
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

# Compact the prompts of previous commands, but keep directory changes extra visible.
POWERLEVEL9K_TRANSIENT_PROMPT=same-dir

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

# Hostname can be relevant, but it usually isn't. I'm only interested in it if connected over SSH, but not when also
# inside TMUX, as this already includes this information in the statusline.
prompt_context_custom() {
	if [[ -n "$TMUX" ]]; then
		SSH_CLIENT= SSH_TTY= POWERLEVEL9K_CONTEXT_TEMPLATE="%n" prompt_context "$@"
	else
		prompt_context "$@"
	fi
}

prompt_nix_shell_packages() {
	p10k segment -i '' -f cyan -e -t '${nix_shell_packages[*]}' -c '${nix_shell_packages:+1}'
}
