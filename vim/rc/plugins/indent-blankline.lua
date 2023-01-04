local function theme_hook()
	vim.cmd('highlight IndentBlanklineCharNormal guifg=#' .. vim.g.base16_gui01 .. ' gui=nocombine')
	vim.cmd('highlight IndentBlanklineCharCurrent guifg=#' .. vim.g.base16_gui0D .. ' gui=nocombine')
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
