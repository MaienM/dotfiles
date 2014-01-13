#
# Helper functions.
#

# This function runs a command delayed.
function delay()
{
  sleep $1 && eval ${@:2}
}

# This function runs a command on a display.
function disp()
{
  #DISPLAY=:0.$1 ${@:2}
  ${@:2}
}

#
# Start of the autostart part.
#

# Stop here if the autorun file has been run before this session. Everything
# after this is "run-once", so to say.
if ! [ -e /tmp/awesomedoautostart ];
then
  exit 0;
fi;
rm /tmp/awesomedoautostart

#
# Start of the run-once part.
#

# Apply .Xresources.
xrdb -merge ~/.Xresources &

# Pulseaudio.
pulseaudio -start &

# Screensaver/lock screen.
xscreensaver -no-splash &

# Numlock.
numlockx &

# Apply .Xmodmap
delay 10 xmodmap .Xmodmap &

# G15 keys.
g15macro &

# R.A.T. 9 mouse bindings.
delay 25 ~/bin/imwheelstart &

# Key bindings.
delay 25 xbindkeys &

# Start irssi in a screen session.
disp 1 xterm -e "tmux new -s irssi irssi" &

# Autostart programs.
disp 0 spotify &
disp 0 skype &
