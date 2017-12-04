# Segments
POWERLEVEL9K_LEFT_PROMPT_ELEMENTS=(context dir vcs)
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

# Default user can be any of these, so check which exist on this system
local possible=(michon maienm)
local existing=()
for user in ${possible[@]}; do
	if id -u $user &> /dev/null; then
		existing+=($user)
	fi
done
# If only a single of these user accounts exists on this machine, set it as the default user
if [ ${#existing} -eq 1 ]; then
	DEFAULT_USER=${existing[1]}
fi
