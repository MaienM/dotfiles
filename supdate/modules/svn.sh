import versioncontrol

CMDS[check]='N=$(svn status --show-updates | grep "*" | grep -cE "[^.]$")'
CMDS[download]='
T=$(svn update) && 
N=$(printf "%s\n" "$T" | grep -c "^... ") &&
T=$(printf "%s\n" "$T" | tail -n1)'
