local rt = require('rust-tools')

rt.setup {
	server = {
		on_attach = function(client, bufnr)
			vim.g.mylsp.on_attach(client, bufnr)
		end,
		settings = {
			['rust-analyzer'] = {
				checkOnSave = {
					command = 'clippy',
				},
			},
		},
	},
}
