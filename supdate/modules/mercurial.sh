CMDS[check]='N=$(hg incoming | grep -c changeset)'
CMDS[download]='N=$(hg pull -u | grep -oE "[0-9]+[^0-9]+" | grep "^[1-9]") && 
                N="${N/%,*/)}" && 
                N="${N/with/(with}"'
TEXT[download]='ifelse "$N" 
               "Checked out $N for $NAME" 
               "Failed to download the updates for $NAME"'
