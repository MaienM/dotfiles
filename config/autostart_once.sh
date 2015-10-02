#!/bin/sh

# Screensaver/lock screen
xscreensaver -no-splash &

# Apply .Xmodmap and xbindkeys
xmodmap .Xmodmap &
xbindkeys &

# Startup often-needed programs
thunderbird &
skype &
google-chrome &
keepass2 &
teamviewer &
