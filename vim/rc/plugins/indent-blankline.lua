local setup_colors = function()
	local colors = require('base16-colorscheme').colors
	vim.cmd('highlight IndentBlanklineCharNormal guifg=' .. colors.base01 .. ' gui=nocombine')
	vim.cmd('highlight IndentBlanklineCharCurrent guifg=' .. colors.base0D .. ' gui=nocombine')
end

setup_colors()

require('ibl').setup {
	exclude = {
		buftypes = {
			'nofile',
			'terminal',
		},
	},
	indent = {
		char = '🭱',
		highlight = 'IndentBlanklineCharNormal',
	},
	scope = {
		highlight = 'IndentBlanklineCharCurrent',
		show_start = false,
		show_end = false,
	},
}

vim.api.nvim_create_autocmd({ 'VimEnter', 'ColorScheme' }, {
	callback = setup_colors,
})
