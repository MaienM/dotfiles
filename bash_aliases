# Make sudo recognize aliases. Don't ask me how it works, I don't have a clue.
alias sudo='A=`alias` sudo  '

# Make ls colorize it's output. Nice to distinguis executable files, folders, broken links, etc.
alias ls='ls --color=auto'

# Added an alias for a nice short overview of unpushed commits.
alias gitlv='git log --oneline --name-status origin/master.. | perl -pe "s/^(\S{4})/\n\1/" | tail -n+2'
