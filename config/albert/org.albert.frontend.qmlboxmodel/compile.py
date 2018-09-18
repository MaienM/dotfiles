#!/usr/bin/env python3


import configparser
import doctest
import os.path
import sys


def color_to_qvariant(r, g, b, a=255):
    """
    Convert a color tuple (red, green, blue, alpha) to a QVariant string.

    The color values should be in the range 0-255 (inclusive).

    - >>> color_to_qvariant(40, 50, 60, 70)
    '@Variant(\\x00\\x00\\x00\x43\\x01\x46\x46\x28\x28\x32\x32\x3C\x3C\\x00\\x00)'
    """
    def chre(c):
        h = hex(c)[2:]
        if len(h) == 1:
            h = f'0{h}'
        return f'\\x{h}'

    # The first 5 characters of the string are fixed.
    data = f'{chre(0)}{chre(0)}{chre(0)}{chre(67)}{chre(1)}'

    # The next 8 characters contain the color information. This is composed of
    # each of the colors converted to a character (8 becomes \x08), duplicated,
    # in the order alpha - red - green - blue. For example, 10 20 30 40 becomes
    # \x28\x28\x0A\x0A\x14\x14\x1E\x1E.
    data += f'{chre(a)}{chre(r)}{chre(r)}{chre(g)}{chre(g)}{chre(b)}{chre(b)}'

    # The final 2 characters are fixed again.
    data += f'{chre(0)}{chre(0)}'

    # This is wrapped in a string that indicates the type of the data.
    return f'@Variant({data})'


def parse_template_color(string):
    """
    Parse a color strimg from the template.

    The format is color_name:option=value:option2=value2.

    The permitted color names are the base* names from base16.

    The permitted options are: red, green, blue, alpha. These override that
    specific part of the chosen color. The values should be in the range 0-255
    (inclusive). Any other options will be silently ignored.

    >>> parse_template_color('base00')
    {'color': 'base00', 'options': {}}
    >>> parse_template_color('base00:red=10:alpha=200')
    {'color': 'base00', 'options': {'red': '10', 'alpha': '200'}}
    """
    parts = string.split(':')
    name = parts[0]
    parts = [part.split('=', 1) for part in parts[1:]]
    options = {part[0]: part[1] for part in parts}
    return {'color': name, 'options': options}


def parse_hexcolor(hexcolor):
    """
    Parse a hexidecimal color representation into a tuple of (red, green, blue,
    alpha), with the values in range 0-255 (inclusive).

    >>> parse_hexcolor('#123456')
    (18, 52, 86, 255)
    >>> parse_hexcolor('#123')
    (17, 34, 51, 255)
    >>> parse_hexcolor('#87654321')
    (135, 101, 67, 33)
    >>> parse_hexcolor('#4321')
    (68, 51, 34, 17)
    >>> parse_hexcolor('#0A2f34')
    (10, 47, 52, 255)
    """
    color = hexcolor
    if color[0] == '#':
        color = color[1:]

    if len(color) == 3 or len(color) == 4:
        parts = [c + c for c in color]
    elif len(color) == 6 or len(color) == 8:
        color += 'FF'
        parts = [color[0:2], color[2:4], color[4:6], color[6:8]]
    else:
        raise ValueError(f'Invalid hexcolor {hexcolor}')

    colors = []
    for part in parts:
        try:
            colors.append(int(part, 16))
        except ValueError:
            raise ValueError(f'Invalid hexcolor {hexcolor}')
    if len(colors) == 3:
        colors.append(255)

    return tuple(colors)


XRESOURCES = os.path.join(os.path.expanduser('~'), '.Xresources.d', 'colors')
TEMPLATE = os.path.join(os.path.dirname(__file__), 'template.ini')
OUTPUT = os.path.join(os.path.dirname(__file__), 'style_properties.ini')


if __name__ == '__main__':
    failure_count, test_count = doctest.testmod()
    if failure_count > 0:
        sys.exit(1)

    # Get the colors from the Xresources
    colors = {}
    with open(XRESOURCES, 'r') as f:
        for line in f:
            if not line.startswith('#define'):
                continue

            _, name, hexcolor = line.split(' ', 3)
            colors[name] = parse_hexcolor(hexcolor.strip())

    # Parse the template
    config = configparser.ConfigParser()
    config.read(TEMPLATE)

    # Go through all values, and process found colors
    for section, proxy in config.items():
        for key, value in proxy.items():
            if not key.endswith('_color'):
                continue

            template_color = parse_template_color(value)
            color = colors[template_color['color']]
            color = (
                int(template_color['options'].get('red', color[0])),
                int(template_color['options'].get('green', color[1])),
                int(template_color['options'].get('blue', color[2])),
                int(template_color['options'].get('alpha', color[3])),
            )
            config.set(section, key, color_to_qvariant(*color))

    # Write the result to the output file
    with open(OUTPUT, 'w') as f:
        config.write(f)
