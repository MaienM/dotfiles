local runtime_path = vim.split(package.path, ';')
table.insert(runtime_path, 'lua/?.lua')
table.insert(runtime_path, 'lua/?/init.lua')

vim.g.mylsp.setup('lua_ls', {
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
				enable = false,
			},
			workspace = {
				library = vim.api.nvim_get_runtime_file('', true),
				checkThirdParty = false,
			},
			telemetry = {
				enable = false,
			},
		},
	},
})

local null_ls = require('null-ls')
null_ls.register(null_ls.builtins.formatting.stylua)
