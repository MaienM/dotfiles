" Reload the tmux config when saving it.
au BufWritePost ~/.tmux.conf silent! !tmux source-file ~/.tmux.conf &> /dev/null
