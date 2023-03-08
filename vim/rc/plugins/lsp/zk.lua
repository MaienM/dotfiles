local notebook_root = vim.env.HOME .. '/coding/projects/zettelkasten'
local media_root = notebook_root .. '/content/media';

vim.env.ZK_NOTEBOOK_DIR = notebook_root;

local function in_zettelkasten()
	return require('zk.util').notebook_root(vim.fn.expand('%:p')) ~= nil
end

local function on_attach(client, bufnr)
	vim.g.mylsp.on_attach(client, bufnr)

	local opts = { noremap = true, silent = false }
	local bufopts = vim.tbl_extend('error', opts, { buffer = bufnr })

	vim.api.nvim_set_keymap('n', '<leader>zz',
		"<Cmd>ZkNotes { sort = { 'modified' }, excludeHrefs = { '" .. media_root .. "' } }<CR>", opts)
	vim.api.nvim_set_keymap('n', '<leader>zt', '<Cmd>ZkTags<CR>', opts)

	vim.api.nvim_set_keymap('n', '<leader>zc', '<Cmd>ZkNew<CR>', opts)
	vim.api.nvim_set_keymap('v', '<leader>zc', "<Cmd>'<,'>ZkNewFromContentSelection<CR>", opts)

	vim.api.nvim_set_keymap('n', '<leader>z/',
		"<Cmd>ZkNotes { sort = { 'modified' }, match = { vim.fn.input('Search: ') } }<CR>", opts)
	vim.api.nvim_set_keymap('v', '<leader>z/', ":'<,'>ZkMatch<CR>", opts)

	if not in_zettelkasten() then
		return
	end

	vim.api.nvim_buf_set_keymap(0, 'n', '<leader>gr', '<Cmd>ZkBacklinks<CR>', opts)
	vim.api.nvim_buf_set_keymap(0, 'n', '<leader>zl', '<Cmd>ZkLinks<CR>', opts)
end

require('zk').setup {
	picker = 'fzf',

	lsp = {
		config = vim.tbl_deep_extend('force', vim.g.mylsp.common_settings, {
			on_attach = on_attach,
		}),
		auto_attach = {
			enabled = true,
			filetypes = { 'markdown' },
		},
	},
}
