#!/usr/bin/env bash
# shellcheck disable=SC2154

# shellcheck source=../functions/strip_escape
. ~/dotfiles/functions/strip_escape

c1="${color_fg_red}a${color_reset}"
c2="${color_bg_red}b${color_reset}"
c3="${color_fg_green}${color_bg_magenta}c${color_reset}"
c4="${color_reverse}${color_fg_magenta}d${color_reset}"

in="12${c1}34${c2}56${c3}78${c4}90"

test_substr() {
	actual="$(printf '%s' "$in" | substring_escape "$1" "$2")"
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

test_substr 0 3 "12${c1}"
test_substr 5 2 "${c2}5"
test_substr 2 -1 "${c1}34${c2}56${c3}78${c4}9"
test_substr 2 -5 "${c1}34${c2}56${c3}"
test_substr 2 -20 ""
test_substr -6 3 "${c3}78"
test_substr -6 100 "${c3}78${c4}90"
test_substr -7 -2 "6${c3}78${c4}"
test_substr -7 -8 ""

