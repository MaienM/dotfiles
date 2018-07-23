# WSL does not have a login session, so ~/.profile is never loaded, so do so now
if $(cat /proc/sys/kernel/osrelease | grep Microsoft &> /dev/null); then
	echo Loading profile...
	export DISPLAY=localhost:0
	export SHELL=$(which zsh)
	source ~/.profile
fi
