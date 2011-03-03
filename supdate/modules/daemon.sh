CMDS[apply]='N=$(sudo bash -c "(kill $(findproc $NAME) &> /dev/null & 
                                rm -f /var/run/daemons/$NAME && 
                                /etc/rc.d/$NAME start)" | grep -c DONE)'
