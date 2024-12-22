vim.g.mylsp.setup('nil_ls', {
	settings = {
		['nil'] = {
			formatting = {
				command = { 'nixfmt' },
			},
		},
	},
})

local null_ls = require('null-ls')
null_ls.register(null_ls.builtins.code_actions.statix)
null_ls.register(null_ls.builtins.diagnostics.deadnix)
null_ls.register(null_ls.builtins.diagnostics.statix)
