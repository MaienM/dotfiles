local null_ls = require('null-ls')

vim.g.mylsp.setup('pyright', {
	settings = {
		pyright = {
			-- Using Ruff's import organizer.
			disableOrganizeImports = true,
		},
	},
	python = {
		analysis = {
			-- Ignore all files for analysis to exclusively use Ruff for linting.
			ignore = { '*' },
		},
	},
})

vim.g.mylsp.setup('ruff_lsp', {
	on_attach = function(client, bufnr)
		--  Disable hover provider as we use pyright for that.
		client.server_capabilities.hoverProvider = false

		vim.g.mylsp.on_attach(client, bufnr)
	end,
})
null_ls.register {
	method = null_ls.methods.FORMATTING,
	filetypes = { 'python' },
	generator = {
		fn = function(params)
			-- Sort imports as part of formatting.
			local ruff_lsp_client = require('lspconfig.util').get_active_client_by_name(params.bufnr, 'ruff_lsp')
			ruff_lsp_client.request('workspace/executeCommand', {
				command = 'ruff.applyOrganizeImports',
				arguments = {
					{ uri = vim.uri_from_bufnr(params.bufnr) },
				},
			}, nil, params.bufnr)
		end,
	},
}
