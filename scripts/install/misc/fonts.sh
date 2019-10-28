#!/usr/bin/env bash

set -o errexit

for cmd in wget svn unzip; do
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
)
rm /tmp/font-setup -rf
