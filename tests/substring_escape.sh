#!/usr/bin/env bash
# shellcheck disable=SC2154

# shellcheck source=../functions/strip_escape
. ~/dotfiles/functions/strip_escape

cr="$color_reset"
cfr="$color_fg_red"
cfg="$color_fg_green"
cfm="$color_fg_magenta"
cbr="$color_bg_red"
cbm="$color_bg_magenta"

#   0,1     2,3    4,5     6,7    8,9          10,11  12,13   15,16  17,18
in="12${cfr}ab${cr}34${cbr}cd${cr}56${cfg}${cbm}ef${cr}78${cfm}gh${cr}90"

test_substr() {
	actual="$(printf '%s' "$in" | substring_escape "$1" "$2")" || exit 1
	expected="$3"
	if [ "$actual" = "$expected" ]; then
		printf '%s "%s"\n' "${color_fg_green}✓${color_reset}" "$actual$color_reset"
	else
		printf '%s substring_escape %d %d\n' "${color_fg_red}×${color_reset}" "$1" "$2"
		printf '  "%s" != "%s"\n' "$actual$color_reset" "$expected$color_reset"
		printf '  %q != %q\n' "$actual" "$expected"
	fi
}

printf 'input "%s" %q\n\n' "$in" "$in"

test_substr 0 3 "12${cfr}a${cr}"
test_substr 6 2 "${cbr}cd${cr}"
test_substr 3 3 "${cfr}b${cr}34"

test_substr 2 -1 "${cfr}ab${cr}34${cbr}cd${cr}56${cfg}${cbm}ef${cr}78${cfm}gh${cr}9"
test_substr 3 -5 "${cfr}b${cr}34${cbr}cd${cr}56${cfg}${cbm}ef${cr}7"
test_substr 2 -20 ""

test_substr -6 3 "78${cfm}g${cr}"
test_substr -6 100 "78${cfm}gh${cr}90"
test_substr -3 100 "${cfm}h${cr}90"

test_substr -7 -2 "${cfg}${cbm}f${cr}78${cfm}gh${cr}"
test_substr -6 -2 "78${cfm}gh${cr}"
test_substr -7 -8 ""
