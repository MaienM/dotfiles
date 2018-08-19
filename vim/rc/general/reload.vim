" Reload config files on save
au BufWritePost vimrc,*.vim silent! source $MYVIMRC
au BufWritePost tmux/* silent! !tmux source ~/.tmux.conf
au BufWritePost i3/config silent! !i3-msg reload
