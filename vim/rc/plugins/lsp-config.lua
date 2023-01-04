local lspconfig = require('lspconfig')

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
	vim.keymap.set('n', '<Leader>af', function()
		vim.lsp.buf.format { async = true }
	end, bufopts)
	vim.keymap.set('n', '<Leader>aa', vim.lsp.buf.code_action, bufopts)

	-- Autoformatting.
	vim.api.nvim_create_autocmd('BufWritePre', {
		callback = function()
			vim.lsp.buf.format { async = false }
		end,
	})
end

-- Calling setup for a server may trigger a restart/reload even if nothing actually changed. This means that whenever we
-- change anything in our vimrc the sumneko server is restarted, which is... obnoxious. To prevent this lets be smart
-- about it and only re-run setup if something actually changed.
vim.g.vimrc_lsp_config_setup_last_configs = vim.g.vimrc_lsp_config_setup_last_configs or {}
local function setup(name, settings)
	-- Every load will result in a new instance of the function, regardless of whether anything actually changed, so
	-- ignore it. It would be nice to be smarter about this somehow, as this will result in changes to the on_attach
	-- function not being picked up on reloads.
	local on_attach = settings.on_attach
	settings.on_attach = nil

	local last_configs = vim.g.vimrc_lsp_config_setup_last_configs
	if vim.deep_equal(settings, last_configs[name]) then
		return
	end

	settings.on_attach = on_attach
	last_configs[name] = settings
	vim.g.vimrc_lsp_config_setup_last_configs = last_configs

	lspconfig[name].setup(settings)
end

-- General server setup.
local common_setup_data = {
	on_attach = on_attach,
	capabilities = require('cmp_nvim_lsp').default_capabilities(),
}
for _, name in ipairs { 'pyright', 'rust_analyzer', 'tsserver' } do
	setup(name, common_setup_data)
end

-- Setup sumneko server for Neovim lua.
do
	local runtime_path = vim.split(package.path, ';')
	table.insert(runtime_path, 'lua/?.lua')
	table.insert(runtime_path, 'lua/?/init.lua')

	setup('sumneko_lua', {
		unpack(common_setup_data),
		settings = {
			Lua = {
				runtime = {
					version = 'LuaJIT',
					path = runtime_path,
				},
				diagnostics = {
					globals = { 'vim' },
				},
				format = {
					enable = true,
				},
				workspace = {
					library = vim.api.nvim_get_runtime_file('', true),
				},
				telemetry = {
					enable = false,
				},
			},
		},
	})
end
