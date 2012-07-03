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
  DISPLAY=:0.$1 ${@:2}
}

#
# Start of the autostart part.
#

# Restore the backgrounds.
delay 30 nitrogen --restore &

# Stop here if the autorun file has been run before this session. Everything
# after this is "run-once", so to say.
if ! [ -e ~/.config/awesome/doautostart ];
then
  exit 0;
fi;
rm ~/.config/awesome/doautostart

#
# Start of the run-once part.
#

# Screensaver/lock screen.
xscreensaver -no-splash &

# Caffeine, to stop xscreensaver from messing around while certain applications
# are running.
caffeine &

# Numlock.
numlockx &

# Volume control.
delay 20 disp 0 obmixer &

# Fix the microphone.
fixmic &

# Apply .Xresources.
xrdb -merge ~/.Xresources &

# Apply .Xmodmap
delay 10 xmodmap .Xmodmap &

# G15 keys.
g15macro &

# R.A.T. 9 mouse bindings.
delay 25 imwheelstart &

# Key bindings.
delay 25 xbindkeys &

# ZNC
#znc > /dev/null &

# BitlBee.
#keeprunning bitlbee -n -d ~/.bitlbee &> /dev/null &

# Start irssi in a screen session.
disp 1 xterm -e "screen irssi" &

# Autostart programs.
disp 0 quodlibet &
disp 0 pidgin & 
disp 0 skype &

disp 1 keeprunning firefox &

# Start playing quodlibet after 30 seconds.
delay 30 quodlibet --play &
