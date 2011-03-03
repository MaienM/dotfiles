CMDS[check]='N=$(git status | grep "behind" | grep -oE [0-9]+)'
CMDS[refresh]='git fetch -q >> /dev/null'
CMDS[download]='git pull >> /dev/null'
