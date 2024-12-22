local lspconfig = require('lspconfig')
local lspformat = require('lsp-format')
local null_ls = require('null-ls')

-- [D]iagnostics mappings.
local opts = { noremap = true, silent = true }
vim.keymap.set('n', '[d', function()
	vim.diagnostic.jump { count = -1, float = true }
end, opts)
vim.keymap.set('n', ']d', function()
	vim.diagnostic.jump { count = 1, float = true }
end, opts)

local function on_attach(client, bufnr)
	-- Enable completion triggered by <c-x><c-o>
	vim.api.nvim_set_option_value('omnifunc', 'v:lua.vim.lsp.omnifunc', { buf = bufnr })

	local bufopts = { noremap = true, silent = true, buffer = bufnr }
	-- Misc mappings.
	vim.keymap.set('n', 'K', vim.lsp.buf.hover, {
		desc = 'Show hover information',
		unpack(bufopts),
	})

	-- [G]o-to mappings.
	vim.keymap.set('n', 'gd', vim.lsp.buf.definition, {
		desc = 'Go to definition',
		unpack(bufopts),
	})
	vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, {
		desc = 'Go to declaration',
		unpack(bufopts),
	})
	vim.keymap.set('n', '<Leader>gi', vim.lsp.buf.implementation, {
		desc = 'Go to implementation',
		unpack(bufopts),
	})
	vim.keymap.set('n', '<Leader>gr', vim.lsp.buf.references, {
		desc = 'Show references',
		unpack(bufopts),
	})
	vim.keymap.set('n', '<Leader>go', vim.lsp.buf.document_symbol, {
		desc = 'Show document outline',
		unpack(bufopts),
	})
	vim.keymap.set('n', '<Leader>gO', vim.lsp.buf.workspace_symbol, {
		desc = 'Search in workspace outline',
		unpack(bufopts),
	})

	-- [A]ction mappings.
	vim.keymap.set('n', '<Leader>aa', vim.lsp.buf.code_action, {
		desc = 'Show actions',
		unpack(bufopts),
	})
	vim.keymap.set('v', '<Leader>aa', vim.lsp.buf.code_action, {
		desc = 'Show actions',
		unpack(bufopts),
	})

	-- Autoformatting.
	lspformat.on_attach(client, bufnr)

	-- Inlay hints.
	vim.lsp.inlay_hint.enable()
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
null_ls.reset_sources()
null_ls.setup {
	on_attach = on_attach,
}

-- Store in global var for use in other rc files.
vim.g.mylsp = {
	on_attach = on_attach,
	common_settings = common_settings,
	setup = setup,
}

-- Colorscheme additions.
local setup_colors = function()
	-- Blend two color to get one for this.
	local get = function(color, idx)
		return tonumber(string.sub(color, idx * 2, idx * 2 + 1), 16)
	end
	local blend = function(color_a, color_b)
		return string.format(
			"#%02x%02x%02x",
			(get(color_a, 1) + get(color_b, 1)) / 2,
			(get(color_a, 2) + get(color_b, 2)) / 2,
			(get(color_a, 3) + get(color_b, 3)) / 2
		)
	end

	local colors = require('base16-colorscheme').colors
	vim.cmd('highlight LspInlayHint guifg=' .. blend(colors.base01, colors.base02) .. ' gui=nocombine')
end
setup_colors()
vim.api.nvim_create_autocmd({ 'VimEnter', 'ColorScheme' }, {
	callback = setup_colors,
})

-- Load submodules.
vim.cmd('runtime! rc/plugins/lsp/*.lua')
