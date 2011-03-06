import 'versioncontrol'

CMDS[check]='
O=$(git status | head -n3) && 
N=$(
(
  echo $O | grep behind ||
  echo $O | grep diverged | grep -oE "[0-9]+ different"
) | grep -oE [0-9]+ || echo 0)'
CMDS[refresh]='git fetch -q >> /dev/null'
CMDS[download]='
T=$(git pull | grep changed | cut -c 2-) &&
N=$(echo $T | grep -oE ^[0-9]+)'
