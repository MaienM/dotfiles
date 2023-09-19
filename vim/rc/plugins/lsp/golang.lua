vim.g.mylsp.setup('gopls')

local null_ls = require('null-ls')
null_ls.register(null_ls.builtins.formatting.goimports)
