require('noice').setup {
	lsp = {
		override = {
			['vim.lsp.util.convert_input_to_markdown_lines'] = true,
			['vim.lsp.util.stylize_markdown'] = true,
		},
	},
	presets = {
		lsp_doc_border = true,
	},

	views = {
		cmdline_popup = {
			position = {
				row = '33%',
				col = '50%',
			},
		},
	},

	cmdline = {
		format = {
			perl = {
				pattern = '^:perl%s+',
				icon = '',
				lang = 'perl',
				opts = { border = { text = { top = ' Perl ' } } },
			},
			python = {
				pattern = '^:pyt?h?o?n?[3x]?%s+',
				icon = '',
				lang = 'python',
				opts = { border = { text = { top = ' Python ' } } },
			},
			ruby = {
				pattern = '^:ruby%s+',
				icon = '',
				lang = 'ruby',
				opts = { border = { text = { top = ' Ruby ' } } },
			},

			ripgrepraw = {
				pattern = '^:RgRaw!?%s+',
				icon = ' ',
				lang = 'regex',
				opts = { border = { text = { top = ' ripgrep (raw) ' } } },
			},
			ripgrep = {
				pattern = '^:Rg!?%s+',
				icon = ' ',
				lang = 'regex',
				opts = { border = { text = { top = ' ripgrep ' } } },
			},
			increname = {
				pattern = '^:IncRename%s+',
				icon = '',
				opts = {
					relative = 'cursor',
					size = { min_width = 20 },
					position = { row = -2, col = 0 },
					buf_options = { filetype = 'text' },
					border = { text = { top = ' Rename ' } },
				},
			},
		},
	},

	routes = (function()
		-- Convenience functions for rules.
		local function skip(filter)
			return {
				filter = filter,
				opts = { skip = true },
			}
		end

		local function view(name, filter)
			return {
				filter = filter,
				view = name,
			}
		end

		-- Convenience functions for filters.
		local function filter_msg(pattern, kind)
			return {
				event = 'msg_show',
				kind = kind or '',
				find = pattern,
			}
		end

		local function filter_error(code)
			return filter_msg('^E' .. code .. ':', 'emsg')
		end

		return {
			-- No write since last change for buffer "{name}"
			view('mini', filter_error(162)),
			-- No write since last change (add ! to override)
			view('mini', filter_error(37)),
			-- No write since last change for buffer {N} (add ! to override)
			view('mini', filter_error(89)),
			-- Mark not set.
			skip(filter_error(20)),

			-- File written messages.
			view('mini', filter_msg('%d+B written$')),
			view('mini', filter_msg('^<$')),
			view('mini', filter_msg('^:!scp')),

			-- Undo/redo messages.
			view('mini', filter_msg('^%d% changes?')),
			view('mini', filter_msg('^%d% more lines?')),
			view('mini', filter_msg('^%d% fewer lines?')),
			view('mini', filter_msg('^1 line more;')),
			view('mini', filter_msg('^1 line less;')),
			view('mini', filter_msg('^Already at newest change$')),
			view('mini', filter_msg('^Already at oldest change$')),
			skip(filter_msg('^Writing undo file:')),

			-- Pattern not found.
			view('mini', filter_error(486)),
			-- Search wrapping around.
			skip(filter_msg('search hit BOTTOM', 'wmsg')),
			skip(filter_msg('search hit TOP', 'wmsg')),

			-- No information available (happens when no LSP hover information is available).
			view('mini', { event = 'notify', kind = 'info', find = '^No information available$' }),

			-- Status message that is (a) not very useful and (b) shown too frequently, especially when multiple files get (re)evaluated at once.
			skip {
				event = 'lsp',
				kind = 'progress',
				cond = function(message)
					local client = vim.tbl_get(message.opts, 'progress', 'client')
					local source = vim.tbl_get(message.opts, 'progress', 'message')
					local title = vim.tbl_get(message.opts, 'progress', 'title')
					return client == 'null-ls' and source == 'editorconfig_checker' and title == 'diagnostics_on_open'
				end,
			},

			-- Ruff format message. This is run as part of formatting, so this appears on every save.
			skip(filter_msg('Workspace edit Ruff: Format imports')),
		}
	end)(),
}

local function map_hover_scroll(key, delta)
	vim.keymap.set('n', key, function()
		if not require('noice.lsp').scroll(delta) then
			return key
		end
	end, { silent = true, expr = true })
end

map_hover_scroll('<M-j>', 1)
map_hover_scroll('<M-k>', -1)
map_hover_scroll('<M-h>', -10)
map_hover_scroll('<M-l>', 10)
