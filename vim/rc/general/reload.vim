" Reload config files on save.
au BufWritePost vimrc,*.vim,vim/**/*.lua silent! source $MYVIMRC
au BufWritePost tmux/* silent! !tmux source ~/.tmux.conf
au BufWritePost */i3/config silent! !DISPLAY=:0 i3-msg reload
