require('neodev').setup {
	pathStrict = true,
}

vim.g.mylsp.setup('lua_ls', {
	settings = {
		Lua = {
			format = {
				enable = false,
			},
			telemetry = {
				enable = false,
			},
			workspace = {
				library = {
					---@diagnostic disable-next-line: param-type-mismatch
					unpack(vim.fn.expand('~/.vim/bundle/*/lua', false, true)),
					---@diagnostic disable-next-line: param-type-mismatch
					unpack(vim.fn.expand('~/.vim/bundle-nvim/*/lua', false, true)),
				},
				ignoreDir = {
					'.direnv',
				},
				checkThirdParty = false,
			},
		},
	},
})

local null_ls = require('null-ls')
null_ls.register(null_ls.builtins.formatting.stylua)
