#!/usr/bin/env sh

# Install driver from aur
pikaur -S brother-hl2130

# Add printer
sudo lpadmin -x Brother_HL_2130 
sudo lpadmin -p Brother_HL_2130 -E -v 'lpd://192.168.2.254/LPRServer' -m "HL2130.ppd"

echo "To set printer as default run 'lpoptions -d Brother_HL_2130'."
