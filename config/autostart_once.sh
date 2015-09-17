#!/bin/sh

# Screensaver/lock screen
xscreensaver -no-splash &

# Apply .Xmodmap
delay 10 xmodmap .Xmodmap &

# Startup often-needed programs
thunderbird &
skype &
google-chrome &
keepass2 &
teamviewer &
