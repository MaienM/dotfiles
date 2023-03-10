local null_ls = require('null-ls')

-- The yamlfmt binary we have installed is not actually the one this source is made for, but the CLI happens to match so
-- we can just use it as-is.
null_ls.register(null_ls.builtins.formatting.yamlfmt)
