vim.opt.completeopt:append('menu')
vim.opt.completeopt:append('menuone')
vim.opt.completeopt:append('noselect')

local function has_words_before()
	unpack = unpack or table.unpack
	local line, col = unpack(vim.api.nvim_win_get_cursor(0))
	return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match('%s') == nil
end

local cmp = require('cmp')
local lspkind = require('lspkind')
local luasnip = require('luasnip')

cmp.setup {
	snippet = {
		expand = function(args)
			require('luasnip').lsp_expand(args.body)
		end,
	},
	window = {
		completion = cmp.config.window.bordered(),
		documentation = cmp.config.window.bordered(),
	},
	mapping = cmp.mapping.preset.insert {
		['<Tab>'] = cmp.mapping(function(fallback)
			if cmp.visible() then
				cmp.select_next_item()
			elseif luasnip.expandable() then
				luasnip.expand()
			elseif has_words_before() then
				cmp.complete()
			else
				fallback()
			end
		end, { 'i', 's' }),
		['<S-Tab>'] = cmp.mapping(function(fallback)
			if cmp.visible() then
				cmp.select_prev_item()
			else
				fallback()
			end
		end, { 'i', 's' }),

		['<M-j>'] = cmp.mapping.scroll_docs(1),
		['<M-k>'] = cmp.mapping.scroll_docs(-1),
		['<M-h>'] = cmp.mapping.scroll_docs(-10),
		['<M-l>'] = cmp.mapping.scroll_docs(10),

		['<C-e>'] = cmp.mapping.abort(),
		['<CR>'] = cmp.mapping.confirm(),
	},
	sources = cmp.config.sources({
		{ name = 'nvim_lsp' },
		{ name = 'luasnip' },
	}, {
		{ name = 'buffer' },
		{ name = 'path' },
	}),
	formatting = {
		fields = { 'kind', 'abbr' },
		format = function(...)
			local result = lspkind.cmp_format {
				mode = 'symbol',
				maxwidth = 50,
				ellipsis_char = '...',
			}(...)
			result.menu = nil -- Even though this field is not used it still affects the width if set.
			return result
		end,
	},
}

-- Use buffer source for `/` and `?` (if you enabled `native_menu`, this won't work anymore).
cmp.setup.cmdline({ '/', '?' }, {
	mapping = cmp.mapping.preset.cmdline(),
	sources = {
		{ name = 'buffer' },
	},
})
-- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
cmp.setup.cmdline(':', {
	mapping = cmp.mapping.preset.cmdline(),
	sources = cmp.config.sources({
		{ name = 'path' },
	}, {
		{ name = 'cmdline' },
	}),
})
