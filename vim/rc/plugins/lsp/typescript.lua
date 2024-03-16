local null_ls = require('null-ls')

require('typescript-tools').setup {
	on_attach = function(client, bufnr)
		-- Formatting is handled with dprint & ESLint.
		client.server_capabilities.documentFormattingProvider = false
		client.server_capabilities.documentRangeFormattingProvider = false

		vim.g.mylsp.on_attach(client, bufnr)
	end,
	settings = vim.tbl_deep_extend('force', vim.g.mylsp.common_settings, {
		tsserver_file_preferences = {
			includeInlayParameterNameHints = 'all',
			includeInlayEnumMemberValueHints = true,
			includeInlayFunctionLikeReturnTypeHints = true,
			includeInlayFunctionParameterTypeHints = true,
			includeInlayPropertyDeclarationTypeHints = true,
			includeInlayVariableTypeHints = true,
		},
	}),
}

vim.g.mylsp.setup('eslint')
null_ls.register {
	method = null_ls.methods.FORMATTING,
	filetypes = {},
	generator = {
		fn = function(params)
			-- Run ESLint fix all as part of formatting.
			local eslint_lsp_client = require('lspconfig.util').get_active_client_by_name(params.bufnr, 'eslint')
			if eslint_lsp_client then
				vim.cmd('EslintFixAll')
			end
		end,
	},
}
