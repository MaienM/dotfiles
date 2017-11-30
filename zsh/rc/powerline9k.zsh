# Segments
POWERLEVEL9K_LEFT_PROMPT_ELEMENT=(context dir rbenv vcs)
POWERLEVEL9K_RIGHT_PROMPT_ELEMENTS=(status command_execution_time root_indicator background_jobs history time)

# Multiline with empty line above
POWERLEVEL9K_PROMPT_ADD_NEWLINE=true
POWERLEVEL9K_PROMPT_ON_NEWLINE=true
POWERLEVEL9K_MULTILINE_FIRST_PROMPT_PREFIX=""
POWERLEVEL9K_MULTILINE_LAST_PROMPT_PREFIX="%{%B%F{yellow}%K{black}%} $user_symbol%{%b%f%k%F{black}%} %{%f%}"

# Status of last command if needed
POWERLEVEL9K_STATUS_OK=false

# Short path + write status
POWERLEVEL9K_SHORTEN_DIR_LENGTH=3
POWERLEVEL9K_SHORTEN_STRATEGY='truncate_from_right'
POWERLEVEL9K_DIR_SHOW_WRITABLE=true
