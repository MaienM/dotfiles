#!/usr/bin/env bash

set -o errexit

# shellcheck source=../../../local/bin/commands_require
. commands_require; commands_require fontforge python

rm /tmp/icon-setup -rf
mkdir /tmp/icon-setup
(
	cd /tmp/icon-setup
	echo ">>> Exporting nerdfont symbols as SVGs"
	# shellcheck disable=SC2016
	fontforge 2>&1 -quiet -lang=ff -c 'Open($1); SelectWorthOutputting(); foreach Export("%u.svg"); endloop;' \
		"$HOME/.local/share/fonts/Symbols-2048-em Nerd Font Complete.ttf" \
	| (grep -v 'mapped to' || true)
	rm -rf ~/.local/share/icons/nerdfonts/
	mkdir -p ~/.local/share/icons/nerdfonts/
	mapped=0
	missing=0
	while read -r line; do
		name="${line%=*}"
	 	symbol="${line#*=}"
		if [ -f "$symbol.svg" ]; then
			mv "$symbol.svg" "$HOME/.local/share/icons/nerdfonts/${name#i_}.svg"
			mapped=$((mapped + 1))
		else
			missing=$((missing + 1))
		fi
	done < <(
		# shellcheck disable=SC1090
		source ~/.local/bin/nerdfonts_icons_all;
		set | grep '^i_' | python -c '
import sys
for line in sys.stdin: 
	name, symbol = line.strip().split("=", 2)
	symbol = symbol.encode("unicode_escape").decode("utf-8")[2:]
	print(f"{name}={symbol}")
	'
)
	echo "Exported SVGs for $mapped icons, $missing icons do not have an SVG"
)
rm /tmp/icon-setup -rf

