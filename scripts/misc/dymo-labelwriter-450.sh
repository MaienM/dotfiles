#!/usr/bin/env sh

# Install driver from aur
pikaur -S dymo-cups-drivers

# Add printer
sudo lpadmin -x Dymo_LabelWriter_450 
sudo lpadmin -p Dymo_LabelWriter_450 -E -v 'usb://DYMO/LabelWriter%20450?serial=01010112345600' -m "lw450.ppd"
