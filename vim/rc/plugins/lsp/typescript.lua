vim.g.mylsp.setup('tsserver')

local null_ls = require('null-ls')
null_ls.register(null_ls.builtins.code_actions.eslint_d)
null_ls.register(null_ls.builtins.diagnostics.eslint_d)
null_ls.register(null_ls.builtins.formatting.eslint_d)
