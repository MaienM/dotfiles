-- Setup transform of diagnostics to strip unwanted characters.
local neotest_ns = vim.api.nvim_create_namespace('neotest')
vim.diagnostic.config({
	virtual_text = {
		format = function(diagnostic)
			return diagnostic
				.message
				-- Expand tabs.
				:gsub('\t', ' ')
		end,
	},
}, neotest_ns)

local neotest = require('neotest')
---@diagnostic disable-next-line: missing-fields
neotest.setup {
	adapters = {
		require('neotest-go'),
		require('neotest-python') {
			dap = { justMyCode = false },
		},
		require('neotest-rust'),
	},
}

vim.keymap.set('n', '<Leader>tc', neotest.run.run)
vim.keymap.set('n', '<Leader>tf', function()
	neotest.run.run(vim.fn.expand('%'))
end)
vim.keymap.set('n', '<Leader>ta', function()
	neotest.run.run(vim.lsp.buf.list_workspace_folders()[1])
end)
vim.keymap.set('n', '<Leader>tt', neotest.run.run_last)
vim.keymap.set('n', '<Leader>tA', neotest.run.attach)
vim.keymap.set('n', '<Leader>tS', neotest.run.stop)

vim.keymap.set('n', '<Leader>to', neotest.output_panel.toggle)
vim.keymap.set('n', '<Leader>ts', neotest.summary.toggle)
vim.keymap.set('n', '<Leader>tW', neotest.watch.toggle)
