# Make sudo recognize aliases. Don't ask me how it works, I don't have a clue.
alias sudo='A=`alias` sudo  '

# Make ls colorize it's output. Nice to distinguis executable files, folders, broken links, etc.
alias ls='ls --color=auto'

# Lock the screen.
alias lock='xscreensaver-command -lock'

# Mute/unmute the system+tottle playing in quidlibet.
alias mute='mute && quodlibet --play-pause'

# Print $1 or, when $1 is empty, $2.
function echoe()
{
  A=
  while [[ ${1::1} == '-' ]]
  do
    A="$A$1 "
    shift
  done
  if [[ -n $1 ]]
  then
    echo $A $1
  else
    echo $A $2
  fi
}

#
# Some aliases for git.
#

# Some shortcuts.
alias gits='git status'

# Log.
alias gitlv='git log --oneline --name-status'
alias gitlvuc='gitlv origin/master..'

# Other.
alias gitrb='git rebase --interactive'
alias gitrbu='gitrb origin/master..'
