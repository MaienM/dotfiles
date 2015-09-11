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
  # ${@:2}
}

# This function runs a command, but only if no such command is currently running.
# Default behavior is to pgrep for the entire passed command. If this is not
# correct, pass what should be pgrepped as the second parameter.
function ifneeded()
{
  PG="$1"
  if [ -n "$2" ]; then
    PG="$2";
  fi
  if [ -z "$(pgrep "$PG")" ]; then
    eval $1;
  fi
}

#
# Start of the autostart part.
#

monlp

# Apply .Xresources.
xrdb -merge ~/.Xresources &

# Screensaver/lock screen.
ifneeded xscreensaver -no-splash &

# Numlock.
numlockx &

# Apply .Xmodmap
delay 10 xmodmap .Xmodmap &

# Key bindings.
# delay 25 xbindkeys &

# Autostart programs.
disp 0 ifneeded "skype" &
disp 0 ifneeded "google-chrome" "chrome" &
disp 1 ifneeded "keepass2" &
disp 1 ifneeded "teamviewer" &
