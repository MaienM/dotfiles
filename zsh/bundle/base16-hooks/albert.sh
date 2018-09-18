#!/usr/bin/env bash

set -o errexit

# Build the theme from the template.
python ~/.config/albert/org.albert.frontend.qmlboxmodel/compile.py

# Restart albert to apply the config.
killall albert || true
sleep 0.5
DISPLAY=:0 nohup albert &> /dev/null &
