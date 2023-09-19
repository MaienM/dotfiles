#!/usr/bin/env cached-nix-shell
#!nix-shell -i sh
#!nix-shell -p fontforge

set -o errexit

rm -rf ~/.local/share/icons/nerdfonts/
mkdir -p ~/.local/share/icons/nerdfonts/
(
	cd ~/.local/share/icons/nerdfonts/

	echo ">>> Exporting nerdfont symbols as SVGs"
	# shellcheck disable=SC2016
	fontforge 2>&1 -quiet -lang=ff -c 'Open($1); SelectWorthOutputting(); foreach Export("%u.svg"); endloop;' \
		"$HOME/.nix-profile/share/fonts/truetype/NerdFonts/Symbols-2048-em Nerd Font Complete.ttf" \
		| (grep -v 'mapped to' || true)

	echo "Exported SVGs for $(ls -1 | wc -l) icons"
)
