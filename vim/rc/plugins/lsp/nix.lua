vim.g.mylsp.setup('nil_ls')

local null_ls = require('null-ls')
null_ls.register(null_ls.builtins.formatting.nixpkgs_fmt)
