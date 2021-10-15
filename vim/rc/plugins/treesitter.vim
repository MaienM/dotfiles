if !has('nvim')
	finish
endif

lua <<END
	require'nvim-treesitter.configs'.setup {
		ensure_installed = 'maintained',
		highlight = {
			enable = true,
		},
		incremental_selection = {
			enable = true,
		},
		textobjects = {
			enable = true,
		},
	}
END

set foldmethod=expr
set foldexpr=nvim_treesitter#foldexpr()
