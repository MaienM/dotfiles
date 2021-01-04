#!/usr/bin/env sh

set -e

mkdir -p /tmp/base16-dircolors
cd /tmp/base16-dircolors

# Setup structure expected by pybase16-builder.
if [ ! -d "sources" ]; then
	mkdir sources sources/templates
	git clone "https://github.com/chriskempson/base16-schemes-source.git" sources/schemes
	echo "gnu-dircolors: https://github.com/embayer/base16-gnu-dircolors" > sources/templates/list.yaml
	run-in-asdf python utils pybase16 update -c
fi

# Use builder to generate the script for the new theme.
run-in-asdf python utils pybase16 build -t gnu-dircolors -s "$BASE16_THEME" > /dev/null

# Setup structure that the script expects.
mkdir -p templates/gnu-dircolors/scripts
mv "output/gnu-dircolors/scripts/base16-$BASE16_THEME.py" templates/gnu-dircolors/scripts/template.py

# Run script and store output for use in rc files.
python templates/gnu-dircolors/scripts/template.py > ~/.dircolors
