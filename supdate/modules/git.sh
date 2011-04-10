import 'versioncontrol'

CMDS[check]='
T=$(git log --oneline HEAD..origin/master) &&
N=$(echo -ne $T | wc -l)'
CMDS[refresh]='git fetch -q >> /dev/null'
CMDS[download]='
C=$(git log --oneline HEAD..origin/master) &&
T=$(git pull | grep changed | cut -c 2-) &&
N=$(echo $T | grep -oE ^[0-9]+)'
