require('noice').setup {
	lsp = {
		override = {
			['vim.lsp.util.convert_input_to_markdown_lines'] = true,
			['vim.lsp.util.stylize_markdown'] = true,
			['cmp.entry.get_documentation'] = true,
		},
	},

	views = {
		cmdline_popup = {
			position = {
				row = "33%",
				col = '50%',
			},
		},
	},

	cmdline = {
		format = {
			increname = {
				pattern = '^:IncRename%s+',
				icon = '',
				opts = {
					relative = 'cursor',
					size = { min_width = 20 },
					position = { row = -2, col = 0 },
					buf_options = { filetype = 'text' },
					border = { text = { top = ' Rename ' } },
				},
			},
		},
	},
}
