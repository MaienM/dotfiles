" Part of my modulized vimrc file.
" Last change: Sun, 24 Feb 2013 16:08:08 +0100

" Force 256 colors with Screen/Tmux 
if match($TERM, "screen-256color")!=-1
  set t_Co=256
endif

" Reload the tmux config when saving it.
au BufWritePost ~/.tmux.conf silent! !tmux source-file ~/.tmux.conf &> /dev/null

" Fix certain incoming keystrokes.
execute "set <xUp>=\e[1;*A"
execute "set <xDown>=\e[1;*B"
execute "set <xRight>=\e[1;*C"
execute "set <xLeft>=\e[1;*D"
imap [Z <S-Tab>
