function on_resize()
	local lines = vim.opt.lines._value
	local line33 = math.floor(lines / 3)

	require("noice").setup {
		views = {
			-- Like the command_palette preset, but moved down to a more comfortable position.
			cmdline_popup = {
				position = {
					row = line33,
					col = "50%",
				},
			},
			popupmenu = {
				position = {
					row = line33 + 3,
					col = "50%",
				},
				size = {
					width = 60,
					height = "auto",
					max_height = 15,
				},
				border = {
					style = "rounded",
					padding = { 0, 1 },
				},
				win_options = {
					winhighlight = { Normal = "Normal", FloatBorder = "NoiceCmdlinePopupBorder" },
				},
			},
		},

		lsp = {
			override = {
				["vim.lsp.util.convert_input_to_markdown_lines"] = true,
				["vim.lsp.util.stylize_markdown"] = true,
				["cmp.entry.get_documentation"] = true,
			},
		},
	}
end

vim.api.nvim_create_autocmd('VimResized', { callback = on_resize })
on_resize()
