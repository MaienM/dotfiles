local null_ls = require('null-ls')
null_ls.register(null_ls.builtins.diagnostics.editorconfig_checker)

vim.g.mylsp.setup('dprint', {
	filetypes = {
		'jsonc',
		'json5',
		unpack(require('lspconfig.server_configurations.dprint').default_config.filetypes),
	},
})
