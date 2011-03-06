if [[ -z $PACMAN_COMMAND ]]
then
  PACMAN_COMMAND='pacman'
fi
if [[ -z $PACMAN_DBPATH ]]
then
  PACMAN_DBPATH="$DOTDIR/pacdb"
fi

CMDS[check]='N=$($PACMAN_COMMAND -Qu --dbpath "$PACMAN_DBPATH" | wc -l)'
CMDS[refresh]='(fakeroot $PACMAN_COMMAND -Sy --dbpath "$PACMAN_DBPATH" >> /dev/null)'
CMDS[download]='sudo pacman -Syu --noprogressbar'

