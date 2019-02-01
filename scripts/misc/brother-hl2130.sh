#!/usr/bin/env sh

# Install driver from aur
pikaur -S brother-hl2130

# Add printer
sudo lpadmin -p Brother_HL-2130 -E -v 'lpd://192.168.1.1/LPRServer' -m "HL2130.ppd"
