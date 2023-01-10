" Reload open files when changed by an outside process.
set autoread
autocmd FocusGained,BufEnter,CursorHold,CursorHoldI * if mode() != 'c' | checktime | endif
autocmd FileChangedShellPost * echohl WarningMsg | echo "File changed on disk. Buffer reloaded." | echohl None

" Reload config files on save.
au BufWritePost vimrc,*.vim,vim/**/*.lua silent! source $MYVIMRC
au BufWritePost tmux/* silent! !tmux source ~/.tmux.conf
au BufWritePost */i3/config silent! !DISPLAY=:0 i3-msg reload
