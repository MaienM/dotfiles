#!/usr/bin/env bash

# The paddings, margins and sizes needed in rofi menus will vary based on the resolution.
#
# In general, about 20% of the horizontal space should be padding (10% on each side). The rest should be used for the
# icons. The block with icons should be centered. The 'buttons' should be square, with about 70% of the are being used
# for the icon.

if [ -z "$1" ]; then
	echo >&2 "Usage: $0 [amount-of-items]"
	exit 1
fi

font="FiraCode Nerd Font Mono"
items="$1"

m() {
	bc <<< "scale=3; $1"
}

# Usage: $0 monitor width height
generate_media_block() {
	monid="$1"
	echo
	echo "@media (monitor-id: $monid) {"
	printf '\t%s\n' "// ${2}x${3}"
	generate_resolution_block "$2" "$3" | sed 's/^/\t/'
	echo "}"
}

# Usage: $0 width height
generate_resolution_block() {
	width="$1"
	height="$2"

	aspect() {
		[ "$width" -gt "$height" ] && echo "$1" || echo "$2"
	}

	blocksize=$(m "$(aspect "$width" "$height") * 0.8 / $items")
	iconsize=$(m "$blocksize / 2")
	blockpadding=$(m "($blocksize - $iconsize) / 2")
	fontsize=$(m "$blocksize / 30")
	fontheight=$(m "$fontsize * 2") # TODO: Find a way to get a proper value for this
	textpadding=$(m "$fontsize / 2")

	sed 's/^\t\t//g' << END
		* {
			font: "$font $fontsize";
		}
		window {
			padding: $(
		aspect \
			"$(m "($height - $blocksize) / 2")px 9.999%" \
			"9.999% $(m "($width - $blocksize) / 2")px"
	);
		}
		listview {
			lines: $items;
			layout: $(aspect horizontal vertical);
		}
		element {
			padding: ${blockpadding}px 0 ${textpadding}px 0;
			spacing: $(m "$blockpadding - $fontheight - $textpadding")px;
		}
		element-icon {
			size: ${iconsize}px;
		}
		element-text {
			width: ${blocksize}px;
		}
END
}

# The order of the monitors in rofi seems reversed from xrandr.
echo '@import "themes/iconmenu.rasi"'
index=0
while read -ra moninfo; do
	generate_media_block "$index" "${moninfo[2]}" "${moninfo[4]}"
	((index += 1))
done < <(xrandr --listactivemonitors | tr '/x' ' ' | tail -n+2 | tac)
