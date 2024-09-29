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
	ignore_install = {},
	auto_install = true,
	sync_install = false,

	highlight = {
		enable = true,
	},
	incremental_selection = {
		enable = true,
	},
	indent = {
		enable = true,
	},
	modules = {},
}

vim.opt.foldmethod = 'expr'
vim.opt.foldexpr = 'v:lua.vim.treesitter.foldexpr()'

require('treesitter-context').setup()
