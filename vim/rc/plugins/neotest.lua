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
	consumers = {
		notify = function(client)
			local Message = require('noice-progress')
			local runs = {}

			client.listeners.run = vim.schedule_wrap(function(adapter_id, _, targets)
				-- Cleanup old message.
				local old = runs[adapter_id]
				if old ~= nil then
					old.message:progress({}, true)
				end
				runs[adapter_id] = nil

				-- Create new message.
				local message = Message {
					id = 'neotest:' .. adapter_id .. ':' .. targets[1],
					client = 'neotest',
					title = 'Running tests...',
					message = '0/' .. #targets,
				}

				-- Convert list of targets to table with their names as keys. This is used to detect out results for targets that weren't in this list so that the counts can be kept accurate.
				local target_lookup = {}
				for _, name in ipairs(targets) do
					target_lookup[name] = true
				end

				runs[adapter_id] = {
					message = message,
					count = #targets,
					targets = target_lookup,
				}
			end)

			client.listeners.results = vim.schedule_wrap(function(adapter_id, results, partial)
				local data = runs[adapter_id]
				if data == nil then
					return
				end
				local message = data.message

				local done = 0
				local count = data.count
				for name, _ in pairs(results) do
					done = done + 1
					if not data.targets[name] then
						count = count + 1
					end
				end
				message:progress({
					percentage = 100 * done / count,
					message = done .. '/' .. count,
				}, not partial)

				if not partial then
					runs[adapter_id] = nil
				end
			end)

			return {}
		end,
	},
}

vim.keymap.set('n', '<Leader>tc', neotest.run.run, {
	desc = 'Run the test the cursor is currently in/on',
})
vim.keymap.set('n', '<Leader>tf', function()
	neotest.run.run(vim.fn.expand('%'))
end, {
	desc = 'Run all tests in this file',
})
vim.keymap.set('n', '<Leader>ta', function()
	neotest.run.run(vim.lsp.buf.list_workspace_folders()[1])
end, {
	desc = 'Run all tests in the project',
})
vim.keymap.set('n', '<Leader>tt', neotest.run.run_last, {
	desc = 'Rerun the last run tests',
})
vim.keymap.set('n', '<Leader>tA', neotest.run.attach, {
	desc = 'Attach to the running tests',
})
vim.keymap.set('n', '<Leader>tS', neotest.run.stop, {
	desc = 'Stop the current test run',
})

vim.keymap.set('n', '<Leader>to', neotest.output_panel.toggle, {
	desc = 'Toggle the output panel',
})
vim.keymap.set('n', '<Leader>ts', neotest.summary.toggle, {
	desc = 'Toggle the summary pane',
})
vim.keymap.set('n', '<Leader>tW', neotest.watch.toggle, {
	desc = 'Toggle watch mode',
})
