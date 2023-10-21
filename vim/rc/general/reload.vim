" Reload open files when changed by an outside process.
set autoread
autocmd FocusGained,BufEnter,CursorHold,CursorHoldI * if mode() != 'c' | checktime | endif
autocmd FileChangedShellPost * echohl WarningMsg | echo "File changed on disk. Buffer reloaded." | echohl None

" Reload config files on save.
au BufWritePost vimrc,*.vim,vim/**/*.lua silent! source $MYVIMRC
au BufWritePost tmux/* silent! !tmux source ~/.tmux.conf
au BufWritePost */i3/config silent! !DISPLAY=:0 i3-msg reload

" Reapply colorscheme when changed by an outside process.
if has("nvim")
lua << END
	-- Create watcher, cleaning up previous watcher if one existed.
	if vim.g.base16_reload_watcher_stop ~= nil then
		vim.g.base16_reload_watcher_stop()
	end
	local watch = vim.uv.new_fs_event()
	vim.g.base16_reload_watcher_stop = function()
		watch:stop()
	end

	local function restart_watch()
		local path = vim.api.nvim_get_runtime_file('colors/' .. vim.g.colors_name .. '.{vim,lua}', false)[1]
		watch:stop()
		watch:start(
			path,
			{},
			vim.schedule_wrap(function()
				watch:stop()
				vim.print('Reloading colorscheme.')
				vim.cmd('colorscheme base16') -- This will restart the watch.
			end)
		)
	end
	restart_watch()

	vim.api.nvim_create_autocmd('ColorScheme', {
		callback = vim.schedule_wrap(restart_watch),
	})
END
endif
