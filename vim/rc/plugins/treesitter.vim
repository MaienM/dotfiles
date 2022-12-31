if !has('nvim')
	finish
endif

lua <<END
	require'nvim-treesitter.configs'.setup {
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
END

set foldmethod=expr
set foldexpr=nvim_treesitter#foldexpr()
