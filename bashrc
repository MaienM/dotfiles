# Check for an interactive session
[ -z "$PS1" ] && return

# Set how the bash prompt will look.
# [user@host folder]$ 
PS1="["
E='\$'
if [[ $USER != 'michon' ]]
then
    if [[ $USER == 'root' ]]
    then
        PS1="${PS1}\033[01;31m\]" 
        E='#'
    else
        PS1="${PS1}\033[01;32m\]"
    fi
fi
PS1="${PS1}\u \033[01;34m\]\W\033[00m\]]$E "

# Vim. Need I say more?
export EDITOR="vim"

# Enable tab-completion for sudo.
complete -cf sudo

# Term.
[ "$TERM" = "xterm" ] && TERM="xterm-256color"

# Load the aliases.
[ -e ~/.bash_aliases ] && . ~/.bash_aliases
