" Part of my modulized vimrc file.
" Last change: Thu, 01 Jan 1970 01:00:00 +0100

" Reload the tmux config when saving it.
au BufWritePost ~/.tmux.conf silent! !tmux source-file ~/.tmux.conf &> /dev/null
