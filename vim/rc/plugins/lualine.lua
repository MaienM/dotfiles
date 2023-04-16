local function build_theme()
	local colors = require('base16-colorscheme').colors
	local theme = {}

	theme.normal = {
		a = {
			fg = colors.base00,
			bg = colors.base0D,
		},
		b = {
			fg = colors.base00,
			bg = colors.base02,
		},
		c = {
			fg = colors.base04,
			bg = colors.base01,
		},
	}

	theme.insert = vim.deepcopy(theme.normal)
	theme.insert.a.bg = colors.base0B

	theme.replace = vim.deepcopy(theme.normal)
	theme.replace.a.bg = colors.base09

	theme.visual = vim.deepcopy(theme.normal)
	theme.visual.a.bg = colors.base0E

	theme.command = vim.deepcopy(theme.normal)
	theme.command.a.bg = colors.base0C

	theme.terminal = vim.deepcopy(theme.normal)
	theme.terminal.a.bg = colors.base0A

	theme.inactive = vim.deepcopy(theme.normal)
	theme.inactive.a.fg = colors.base04
	theme.inactive.b.fg = colors.base04
	theme.inactive.c.fg = colors.base04

	return theme
end

local filename = {
	'filename',
	path = 1, -- Relative path
}

-- Encoding segment that's only visible if the encoding is *not* UTF-8.
local function encoding()
	local ret, _ = vim.opt.fileencoding:get():gsub('^utf%-8$', '')
	return ret
end

local fileformat = {
	'fileformat',
	symbols = {
		unix = '', -- Hide unix fileformat as this is kinda the default.
		dos = '',
		mac = '',
	},
}

local filetype = {
	'filetype',
	colored = true,
	icon_only = false,
}

local function location()
	local line = vim.fn.line('.')
	local col = vim.fn.virtcol('.')
	local lines = vim.api.nvim_buf_line_count(0)
	return string.format('%d/%d:%-2d', line, lines, col)
end

require('lualine').setup {
	options = {
		theme = build_theme,
	},

	extensions = {
		'fugitive',
		'fzf',
		'man',
		'quickfix',
	},

	sections = {
		lualine_a = {
			'mode',
		},
		lualine_b = {
			'branch',
		},
		lualine_c = {
			'diff',
			'diagnostics',
			filename,
		},
		lualine_x = {
			encoding,
			fileformat,
			filetype,
		},
		lualine_y = {
			'progress',
		},
		lualine_z = {
			location,
		},
	},
}
