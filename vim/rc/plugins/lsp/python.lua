vim.g.mylsp.setup('pyright')

local null_ls = require('null-ls')
null_ls.register(null_ls.builtins.formatting.autoflake)
null_ls.register(null_ls.builtins.formatting.black)
null_ls.register(null_ls.builtins.formatting.isort)
