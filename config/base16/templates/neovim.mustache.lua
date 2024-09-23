-- vi:ft=lua

vim.g.colors_name = 'base16'

require('base16-colorscheme').setup {
	base00 = '#{{base00-hex}}',
	base01 = '#{{base01-hex}}',
	base02 = '#{{base02-hex}}',
	base03 = '#{{base03-hex}}',
	base04 = '#{{base04-hex}}',
	base05 = '#{{base05-hex}}',
	base06 = '#{{base06-hex}}',
	base07 = '#{{base07-hex}}',
	base08 = '#{{base08-hex}}',
	base09 = '#{{base09-hex}}',
	base0A = '#{{base0A-hex}}',
	base0B = '#{{base0B-hex}}',
	base0C = '#{{base0C-hex}}',
	base0D = '#{{base0D-hex}}',
	base0E = '#{{base0E-hex}}',
	base0F = '#{{base0F-hex}}',
}

-- Set background property based on the perceived lightness of the background color.
if '0{{base00-perceived-lighness}}' / 1 < 50 then
	vim.o.background = 'dark'
else
	vim.o.background = 'light'
end
