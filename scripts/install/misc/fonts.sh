#!/usr/bin/env bash

set -o errexit

for cmd in wget svn unzip fontforge python; do
	if ! command -v "$cmd" &> /dev/null; then
		echo >&2 "The $cmd command is missing"
		exit 1
	fi
done

rm /tmp/font-setup -rf
mkdir /tmp/font-setup
(
	set -o errexit -o pipefail
	cd /tmp/font-setup

	echo '>>> Downloading FiraCode'
	wget 'https://github.com/tonsky/FiraCode/releases/latest' -O - \
		| grep -oE '/tonsky/FiraCode/releases/download/[0-9.]*/FiraCode.*\.zip' \
		| wget --base=http://github.com/ -i - -O FiraCode.zip
	unzip -q -j -o FiraCode.zip
	rm FiraCode.zip

	echo '>>> Downloading Nerd-Fonts'
	svn export -q 'https://github.com/ryanoasis/nerd-fonts/trunk/bin/scripts/lib/'
	svn export -q 'https://github.com/ryanoasis/nerd-fonts/trunk/patched-fonts/FiraCode/'
	svn export -q 'https://github.com/ryanoasis/nerd-fonts/trunk/src/glyphs/Symbols-2048-em Nerd Font Complete.ttf'
	svn export -q 'https://github.com/ryanoasis/nerd-fonts/trunk/10-nerd-font-symbols.conf'

	echo '>>> Installing fonts'
	mkdir -p ~/.local/share/fonts
	find . -name 'Fira*.ttf' -not -name '*Windows*' -exec mv '{}' ~/.local/share/fonts/ \;
	mkdir -p ~/.config/fontconfig/conf.d
	mv ./*.conf ~/.config/fontconfig/conf.d/
	fc-cache -rf

	echo '>>> Installing scripts'
	(
		echo '#!/usr/bin/env bash'
		echo
		echo 'for file in ~/.local/bin/nerdfonts_icons_*; do'
		# shellcheck disable=SC2016
		echo '  [[ "$file" == *"_all" ]] || source "$file"'
		echo 'done'
		echo 'unset file'
	) > ./lib/i_all.sh
	for file in ./lib/i_*.sh; do
		chmod +x "$file"
		name=${file/i_/nerdfonts_icons_}
		name=${name%.sh}
		mv "$file" "$HOME/.local/bin/$name"
		echo "Installed script $name"
	done

	echo ">>> Exporting symbols as SVGs"
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
rm /tmp/font-setup -rf
