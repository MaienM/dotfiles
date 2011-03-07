# Restore the backgrounds.
nitrogen --restore &

# Stop here if the autorun file has been run before this session. Everything
# after this is "run-once", so to say.
if ! [ -e ~/.config/awesome/doautostart ];
then
  exit 0;
fi;
rm ~/.config/awesome/doautostart

# Screensaver/lock screen.
xscreensaver --no-splash &

# Caffeine, to stop xscreensaver from messing around while certain applications
# are running.
caffeine &

# Numlock.
numlockx &

# Volume control.
(sleep 30 && DISPLAY=:0.0 obmixer) &

# Apply .Xresources.
xrdb -merge ~/.Xresources &

# Apply .Xmodmap
(sleep 10 && xmodmap .Xmodmap) &

# G15 keys.
g15macro &

# Autostart programs.
DISPLAY=:0.0 pidgin & 
DISPLAY=:0.0 transmission-gtk & 
DISPLAY=:0.0 quodlibet &

DISPLAY=:0.1 xchat &
DISPLAY=:0.1 firefox &

# Start playing quodlibet after 30 seconds.
(sleep 30 && quodlibet --play) &
