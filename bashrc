# Check for an interactive session
[ -z "$PS1" ] && return

# Set how the bash prompt will look.
# [user@host folder]$ 
PS1='[\u@\h \W]\$ '

# Vim. Need I say more?
export EDITOR="vim"

# Enable tab-completion for sudo.
complete -cf sudo

# Load the aliases.
[[ -e ~/.bash_aliases ]] && . ~/.bash_aliases
