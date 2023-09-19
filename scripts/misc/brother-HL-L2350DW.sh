#!/usr/bin/env sh

# Install driver from aur
pikaur -S --needed brother-hll2350dw

# Add printer
sudo lpadmin -x Brother_HL_L2350DW
sudo lpadmin -p Brother_HL_L2350DW -E -v 'lpd://192.168.2.254/LPRServer' -m "brother-HLL2350DW-cups-en.ppd"

echo "To set printer as default run 'lpoptions -d Brother_HL_L2350DW'."
