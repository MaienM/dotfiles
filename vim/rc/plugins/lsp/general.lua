local null_ls = require('null-ls')
null_ls.register(null_ls.builtins.diagnostics.editorconfig_checker)

if next(vim.fn['xolox#misc#path#which']('dprint')) ~= nil then
	vim.g.mylsp.setup('dprint', {
		filetypes = {
			'jsonc',
			'json5',
			unpack(require('lspconfig.configs.dprint').default_config.filetypes),
		},
	})
end
