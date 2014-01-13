# Make sudo recognize aliases. Don't ask me how it works, I don't have a clue.
#alias sudo='A=`alias` sudo  '

# Make ls colorize it's output. Nice to distinguish executable files, folders, broken links, etc.
alias ls='ls --color=auto'

# Lock the screen.
alias lock='xscreensaver-command -lock || (xscreensaver & sleep 2 && xscreensaver-command -lock)'

# Mute/unmute the system+toggle playing in quidlibet.
alias mute='mute && quodlibet --play-pause'

# Tmux.
#alias tmux='tmux -2'

# Untar and delete a (number of) file(s).
function tarxf()
{
  if [[ ${1::1} == '-' ]]
  then
    ARG=${1:1}
    shift
  fi
  for file in "$@"
  do 
    tar -x"$ARG"f "$file" && rm "$file"
  done
}

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

