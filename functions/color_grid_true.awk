#!/usr/bin/env awk

# This script will print a color spectrum grid using truecolor escape codes.
#
# It accepts some values, which are to be set using the -v name=value arguments:
#   width:
#     The desired width of the grid in characters.
#     $COLUMNS might be a good value for this.
#     Default is 20.
#   height:
#     The desired height of the grid in characters.
#     $LINES might be a good value for this.
#     Default is 10.
#   saturation:
#     The desired saturation of the grid in characters, as a percentage from 0-100.
#     Default is 100.
#   character:
#     The character to print.
#     Using this will mean the grid is printed using foreground colors.
#     If this is not set, the background color will be set instead.

# Awk implementation of HSV to RGB formula from https://en.wikipedia.org/wiki/HSL_and_HSV#From_HSV
#
# H: The hue. 0 <= H < 360
# S: The saturation. 0 <= S <= 100
# V: The value. 0 <= V <= 100
# result: The variable to put the results in.
#   This will be an array of 3 items, r, g, and b respectively, where 0 <= r|g|b <= 255
function hsv_to_rgb(H, S, V, result) {
	delete result
	result[0] = 0
	result[1] = 0
	result[2] = 0

	# Convert to floats
	S = S / 100
	V = V / 100

	# Calculate the chroma
	C = V * S

	# Get the second largest component of the point on the RGB cube matching the hue and chroma
	Hderiv = H / 60
	X = (Hderiv % 2) - 1
	if (X < 0) {
		X = -1 * X
	}
	X = C * (1 - X)

	# Find the point on the cube with matching hue and chroma
	options[0] = sprintf("%f %f %f", C, X, 0)
	options[1] = sprintf("%f %f %f", X, C, 0)
	options[2] = sprintf("%f %f %f", 0, C, X)
	options[3] = sprintf("%f %f %f", 0, X, C)
	options[4] = sprintf("%f %f %f", X, 0, C)
	options[5] = sprintf("%f %f %f", C, 0, X)
	split(options[int(Hderiv)], colors)

	# Match value
	m = V - C
	for (i = 1; i < 4; i++) {
		result[i] = (colors[i] + m) * 255 + 0.9
	}
}

BEGIN {
	if (width ~ /[^0-9]/ || width <= 0) {
		printf("width should be a number > 0, but width=%s\n", width)
		exit 1
	}
	if (height ~ /[^0-9]/ || height <= 0) {
		printf("height should be a number > 0, but height=%s\n", height)
		exit 1
	}
	if (saturation ~ /[^0-9\-.]/ || saturation < 0 || saturation > 100) {
		printf("saturation must be a number where 0 <= saturation <= 100, but saturation=%s\n", saturation)
		exit 1
	}
	if (character ~ /^..+$/) {
		printf("character must be a single character, but character=%s\n", character)
		exit 1
	}

	if (width == "") {
		width = 20;
	}
	if (height == "") {
		height = 10;
	}
	if (saturation == "") {
		saturation = 100;
	}
	if (character == "") {
		format = "\033[48;2;%d;%d;%dm "
	} else {
		format = "\033[38;2;%d;%d;%dm" character
	}

	hue_step = 360 / width
	value_step = 100 / height

	for (row = height; row > 0; row--) {
		printf("\n")
		for (column = 0; column < width; column++) {
			hsv_to_rgb(hue_step * column, saturation, value_step * row, rgb);
			printf(format, rgb[1], rgb[2], rgb[3]);
		}
		printf("\033[m");
	}
}
