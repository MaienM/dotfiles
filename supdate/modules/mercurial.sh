import 'versioncontrol'

CMDS[check]='N=$(hg incoming | grep -c changeset)'
CMDS[download]='
T=$(hg pull -u | grep changeset) &&
N=$(echo $T | grep -oE ^[0-9]+)'
