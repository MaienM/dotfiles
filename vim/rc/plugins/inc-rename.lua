require('inc_rename').setup()

vim.keymap.set('n', '<Leader>an', function()
	return ':IncRename ' .. vim.fn.expand('<cword>')
end, { expr = true })
