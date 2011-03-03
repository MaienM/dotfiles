
# Check for an interactive session
[ -z "$PS1" ] && return

# The first alias is to make sudo recognize aliases. Don't ask me how it works, I don't have a clue.
alias sudo='A=`alias` sudo  '

# Make ls colorize it's output. Nice to distinguis executable files, folders, broken links, etc.
alias ls='ls --color=auto'

# Set how the bash prompt will look.
# [user@host folder]$ 
PS1='[\u@\h \W]\$ '

# Vim. Need I say more?
export EDITOR="vim"

# Enable tab-completion for sudo.
complete -cf sudo
