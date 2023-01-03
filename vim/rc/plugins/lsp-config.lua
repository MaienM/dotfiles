-- [D]iagnostics mappings.
local opts = { noremap = true, silent = true }
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, opts)
vim.keymap.set('n', ']d', vim.diagnostic.goto_next, opts)

local on_attach = function(client, bufnr)
	-- Enable completion triggered by <c-x><c-o>
	vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')

	-- [G]o-to mappings.
	local bufopts = { noremap = true, silent = true, buffer = bufnr }
	vim.keymap.set('n', 'gd', vim.lsp.buf.definition, bufopts)
	vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, bufopts)
	vim.keymap.set('n', '<Leader>gi', vim.lsp.buf.implementation, bufopts)
	vim.keymap.set('n', '<Leader>gr', vim.lsp.buf.references, bufopts)

	-- [A]ction mappings.
	vim.keymap.set('n', '<Leader>an', vim.lsp.buf.rename, bufopts)
	vim.keymap.set('n', '<Leader>af', function()
		vim.lsp.buf.format { async = true }
	end, bufopts)
	vim.keymap.set('n', '<Leader>aa', vim.lsp.buf.code_action, bufopts)
end

local lspconfig = require('lspconfig')
for _, name in ipairs { 'pyright', 'tsserver', 'rust_analyzer' } do
	lspconfig[name].setup {
		on_attach = on_attach,
	}
end
