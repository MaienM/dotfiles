# Make sudo recognize aliases. Don't ask me how it works, I don't have a clue.
alias sudo='A=`alias` sudo  '

# Make ls colorize it's output. Nice to distinguis executable files, folders, broken links, etc.
alias ls='ls --color=auto'

# Some aliases for git.
alias gitlv='git log --oneline --name-status origin/master.. | perl -pe "s/^(\S{4})/\n\1/" | tail -n+2'
alias gitrb='git rebase --interactive --autosquash origin/master'

# Lock the screen.
alias lock='xscreensaver-command -lock'
