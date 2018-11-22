# Segments
POWERLEVEL9K_LEFT_PROMPT_ELEMENTS=(context_custom dir vcs)
POWERLEVEL9K_RIGHT_PROMPT_ELEMENTS=(status command_execution_time root_indicator background_jobs history time)

# Multiline with empty line above
POWERLEVEL9K_PROMPT_ADD_NEWLINE=true
POWERLEVEL9K_PROMPT_ON_NEWLINE=true
POWERLEVEL9K_MULTILINE_FIRST_PROMPT_PREFIX=''
POWERLEVEL9K_MULTILINE_LAST_PROMPT_PREFIX="%{%B%F{yellow}%K{18}%}  $user_symbol%{%b%f%k%F{18}%} %{%f%}"

# Color for the context with base16
POWERLEVEL9K_CONTEXT_DEFAULT_BACKGROUND='18'

# Status of last command if needed
POWERLEVEL9K_STATUS_OK=false

# Short path + write status
POWERLEVEL9K_SHORTEN_DIR_LENGTH=3
POWERLEVEL9K_SHORTEN_STRATEGY='truncate_from_right'
POWERLEVEL9K_DIR_SHOW_WRITABLE=true

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
