#!/usr/bin/env gawk

function fmtsize(size) {
	for (i = 0; size >= 1024 && i < length(suffix); i++) {
		size /= 1024
	}
	result = sprintf("%.1f%s", size, substr(suffix, i, 1))
	sub("\\.0", "", result)
	sub(" ", "", result)
	return color(result, "cyan")
}

function fmtratio(size, compr) {
	ratio = (size > 0) ? compr / size : 1
	if (ratio < 0.5) {
		clr = "green"
	} else if (ratio < 0.9) {
		clr = "yellow"
	} else {
		clr = "red"
	}
	return color(int(ratio * 100) "%", clr)
}

function color(text, name) {
	return colors[name] text color_reset
}

BEGIN {
	suffix = "KMGTP"
	section = 0
	delete lines[0]
	colors["red"] = color_red
	colors["yellow"] = color_yellow
	colors["green"] = color_green
	colors["cyan"] = color_cyan
	colors["magenta"] = color_magenta
}

{
	if (/^Type =/) {
		type = $3
	}
	if (/^Method =/) {
		method = $3
	}

	if (/^-----/) {
		section += 1
	} else if (section == 1) {
		if ($6 == "") {
			# This line has no size
			fcompr = $4
			$1 = $2 = $3 = $4 = ""
			path = substr($0, 5)
			lines[length(lines)] = sprintf("%s (%s)", path, fmtsize(fcompr))
		} else {
			fsize = $4
			fcompr = $5
			$1 = $2 = $3 = $4 = $5 = ""
			path = substr($0, 6)
			lines[length(lines)] = sprintf( \
				"%s (%s -> %s, %s)", \
				path, \
				fmtsize(fsize), \
				fmtsize(fcompr), \
				fmtratio(fsize, fcompr) \
			)
		}
	} else if (section == 2) {
		totalsize = $3
		totalcompr = $4
		totalratio = fmtratio(totalsize, totalcompr)
		$1 = $2 = $3 = $4 = ""
		summary = substr($0, 5)
	}
}

END {
	if (method) {
		method = ", " method
	}

	sub(", ", " and ", summary)
	for (i = 0; i < 2; i++) {
		match(summary, /\<[0-9]+\>/)
		summary = \
			substr(summary, 0, RSTART - 1) \
			color(substr(summary, RSTART, RLENGTH), "magenta") \
			substr(summary, RSTART + RLENGTH)
	}

	printf( \
		"%s archive containing %s (%s -> %s, %s%s)\n\n", \
		color(type, "cyan"), \
		summary, \
		fmtsize(totalsize), \
		fmtsize(totalcompr), \
		fmtratio(totalsize, totalcompr), \
		method \
	)
	for (i = 0; i < length(lines); i++) {
		print lines[i]
	}
}
