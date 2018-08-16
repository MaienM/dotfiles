#!/usr/bin/env bash

set -o errexit

rm /tmp/font-setup -rf
mkdir /tmp/font-setup
(
	set -o errexit
	cd /tmp/font-setup

	# Download InconsolataGo
	echo '>>> Downloading InconsolataGo'
	curl '-#' -O 'http://levien.com/type/myfonts/inconsolata/InconsolataGo-Regular.ttf'
	curl '-#' -O 'http://levien.com/type/myfonts/inconsolata/InconsolataGo-Bold.ttf'

	# Download the nerd-fonts font & scripts
	echo '>>> Downloading Nerd-Fonts'
	curl '-#' -O -L 'https://github.com/ryanoasis/nerd-fonts/archive/master.zip'
	unzip -q -j -o master.zip \
		'nerd-fonts-master/bin/scripts/lib/*' \
		'nerd-fonts-master/patched-fonts/InconsolataGo/*' \
		'nerd-fonts-master/src/glyphs/Symbols-2048-em Nerd Font Complete.ttf' \
		'nerd-fonts-master/10-nerd-font-symbols.conf'
	rm master.zip
	rm *Windows*

	# Install fonts
	echo '>>> Installing fonts'
	mkdir -p ~/.local/share/fonts
	mv *.ttf ~/.local/share/fonts/
	mkdir -p ~/.config/fontconfig/conf.d
	mv *.conf ~/.config/fontconfig/conf.d/
	fc-cache -rf

	# Rewrite the load_all script
	(
		echo '#!/usr/bin/env bash'
		echo
		echo 'for file in ~/.local/bin/nerdfonts_icons_*; do'
		echo '  [[ "$file" == *"_all" ]] || source "$file"'
		echo 'done'
		echo 'unset file'
	) > i_all.sh

	# Install scripts
	echo '>>> Installing scripts'
	for file in i_*.sh; do
		chmod +x "$file"
		name=${file/i_/nerdfonts_icons_}
		name=${name%.sh}
		mv "$file" "$HOME/.local/bin/$name"
		echo "Installed script $name"
	done
)
rm /tmp/font-setup -rf
