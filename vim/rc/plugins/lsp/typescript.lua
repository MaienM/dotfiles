require('typescript-tools').setup {
	on_attach = function(client, bufnr)
		client.server_capabilities.documentFormattingProvider = false
		client.server_capabilities.documentRangeFormattingProvider = false

		vim.g.mylsp.on_attach(client, bufnr)
	end,
	settings = vim.g.mylsp.common_settings,
}

local null_ls = require('null-ls')
null_ls.register(null_ls.builtins.code_actions.eslint_d)
null_ls.register(null_ls.builtins.diagnostics.eslint_d)
null_ls.register(null_ls.builtins.formatting.eslint_d)
