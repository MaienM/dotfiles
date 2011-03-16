# Make sudo recognize aliases. Don't ask me how it works, I don't have a clue.
alias sudo='A=`alias` sudo  '

# Make ls colorize it's output. Nice to distinguis executable files, folders, broken links, etc.
alias ls='ls --color=auto'

# Some aliases for git.
function gitlv()
{ 
  git log --oneline --name-status $(echo ${1:-origin}/master..) | perl -pe "s/^(\S{4})/\n\1/" | tail -n+2
}
alias gitrb='git rebase --interactive origin/master'

# Lock the screen.
alias lock='xscreensaver-command -lock'

# Mute/unmute the system+tottle playing in quidlibet.
alias mute='mute && quodlibet --play-pause'
