vim.g.mylsp.setup('bashls')

local null_ls = require('null-ls')
null_ls.register(null_ls.builtins.diagnostics.zsh)
null_ls.register(null_ls.builtins.formatting.shfmt.with {
	extra_args = { '-bn', '-ci', '-sr' },
})

-- bashls integrates shellcheck, but it doesn't offer an action to ignore an error yet.
null_ls.register(require('none-ls-shellcheck.code_actions'))
