import 'versioncontrol'

CMDS[check]='
T=$(git log --oneline HEAD..origin/master) &&
N=$(echo $T | wc -l)'
CMDS[refresh]='git fetch -q >> /dev/null'
CMDS[download]='
C=$(git log --oneline HEAD..origin/master | sed "s/^\(\S\+\)/  \\\\033[33m\1\\\\033[m/") &&
T=$(git pull | grep changed | cut -c 2-) &&
N=$(echo $T | grep -oE ^[0-9]+)'
