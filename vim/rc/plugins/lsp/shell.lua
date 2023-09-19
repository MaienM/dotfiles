local null_ls = require('null-ls')
null_ls.register(null_ls.builtins.code_actions.shellcheck)
null_ls.register(null_ls.builtins.diagnostics.shellcheck)
null_ls.register(null_ls.builtins.diagnostics.zsh)
null_ls.register(null_ls.builtins.formatting.shfmt.with {
	extra_args = { '-bn', '-ci', '-sr' },
})
