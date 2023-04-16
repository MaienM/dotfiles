require('nvim-treesitter.configs').setup {
	ensure_installed = {
		-- Used by Noice.
		'vim',
		'regex',
		'lua',
		'bash',
		'markdown',
		'markdown_inline',
	},
	auto_install = true,

	highlight = {
		enable = true,
	},
	incremental_selection = {
		enable = true,
	},
	indent = {
		enable = true,
	},
}

vim.opt.foldmethod = 'expr'
vim.opt.foldexpr = require('nvim-treesitter').foldexpr

require('treesitter-context').setup()
