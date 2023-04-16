local function theme_hook()
	local colors = require('base16-colorscheme').colors
	vim.cmd('highlight IndentBlanklineCharNormal guifg=' .. colors.base01 .. ' gui=nocombine')
	vim.cmd('highlight IndentBlanklineCharCurrent guifg=' .. colors.base0D .. ' gui=nocombine')
end

vim.fn.RegisterThemeHook(theme_hook)

require('indent_blankline').setup {
	buftype_exclude = {
		'nofile',
		'terminal',
	},

	char = '🭱',
	show_current_context = true,

	char_highlight_list = { 'IndentBlanklineCharNormal' },
	context_highlight_list = { 'IndentBlanklineCharCurrent' },
}
