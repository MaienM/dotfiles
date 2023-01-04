require('dressing').setup {
	input = {
		-- Handled by noice.
		enabled = false,
	},
	select = {
		enabled = true,
		backend = {
			'fzf',
			'fzf_lua',
			'builtin',
			'nui',
		},
	},
}
