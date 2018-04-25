# WSL does not have a login session, so ~/.profile is never loaded, so do so now
if $(cat /proc/sys/kernel/osrelease | grep Microsoft &> /dev/null); then
	echo Loading profile...
	source ~/.profile
fi
