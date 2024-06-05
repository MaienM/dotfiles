local trouble = require('trouble')

trouble.setup {}

vim.keymap.set('n', ']D', function()
	trouble.open()
	trouble.next('diagnostics', { skip_groups = true, jump = true })
end, {
	desc = 'Next item in Trouble list',
})
vim.keymap.set('n', '[D', function()
	trouble.open()
	trouble.prev('diagnostics', { skip_groups = true, jump = true })
end, {
	desc = 'Previous item in Trouble list',
})
