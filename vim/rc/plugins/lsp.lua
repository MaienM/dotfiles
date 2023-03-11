local lspconfig = require('lspconfig')
local lspformat = require('lsp-format')
local null_ls = require('null-ls')

-- [D]iagnostics mappings.
local opts = { noremap = true, silent = true }
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, opts)
vim.keymap.set('n', ']d', vim.diagnostic.goto_next, opts)

local function on_attach(client, bufnr)
	-- Enable completion triggered by <c-x><c-o>
	vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')

	local bufopts = { noremap = true, silent = true, buffer = bufnr }
	-- Misc mappings.
	vim.keymap.set('n', 'K', vim.lsp.buf.hover, bufopts)

	-- [G]o-to mappings.
	vim.keymap.set('n', 'gd', vim.lsp.buf.definition, bufopts)
	vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, bufopts)
	vim.keymap.set('n', '<Leader>gi', vim.lsp.buf.implementation, bufopts)
	vim.keymap.set('n', '<Leader>gr', vim.lsp.buf.references, bufopts)
	vim.keymap.set('n', '<Leader>go', vim.lsp.buf.document_symbol, bufopts)
	vim.keymap.set('n', '<Leader>gO', vim.lsp.buf.workspace_symbol, bufopts)

	-- [A]ction mappings.
	vim.keymap.set('n', '<Leader>aa', vim.lsp.buf.code_action, bufopts)
	vim.keymap.set('v', '<Leader>aa', vim.lsp.buf.code_action, bufopts)

	-- Autoformatting.
	lspformat.on_attach(client, bufnr)
end

-- General server setup.
local common_settings = {
	on_attach = on_attach,
	capabilities = require('cmp_nvim_lsp').default_capabilities(),
}

-- Calling setup for a server may trigger a restart/reload even if nothing actually changed. This means that whenever we
-- change anything in our vimrc the lua server is restarted, which is... obnoxious. To prevent this lets be smart about
-- it and only re-run setup if something actually changed.
vim.g.vimrc_lsp_config_setup_last_configs = vim.g.vimrc_lsp_config_setup_last_configs or {}
local function setup(name, extra_settings)
	local settings = vim.tbl_deep_extend('force', common_settings, extra_settings or {})

	-- Every load will result in a new instance of the function, regardless of whether anything actually changed, so
	-- ignore it. It would be nice to be smarter about this somehow, as this will result in changes to the on_attach
	-- function not being picked up on reloads.
	local local_on_attach = settings.on_attach
	settings.on_attach = nil

	local last_configs = vim.g.vimrc_lsp_config_setup_last_configs
	if vim.deep_equal(settings, last_configs[name]) then
		return
	end
	last_configs[name] = settings
	vim.g.vimrc_lsp_config_setup_last_configs = last_configs

	lspconfig[name].setup(vim.tbl_extend('error', settings, { on_attach = local_on_attach }))
end

-- Setup null-ls.
null_ls.setup {
	on_attach = on_attach,
}

-- Store in global var for use in other rc files.
vim.g.mylsp = {
	on_attach = on_attach,
	common_settings = common_settings,
	setup = setup,
}

-- Load submodules.
vim.cmd('runtime! rc/plugins/lsp/*.lua')
