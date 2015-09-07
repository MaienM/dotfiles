" Part of my modulized vimrc file.
" Last change: Fri, 05 Sep 2014 11:12:26 +0200

" Update the first timestamp found in the top 10 lines of a file.
" if exists("*strftime")
"   au BufWrite * mark ' | silent! 0,/\%<11l/call UpdateTimestamp() | ''
" endif

" Make files that start with a shebang (#!...) executable.
au BufWritePost * 
\ if getline(1) =~ "^#!" |
\   if getline(1) =~ "/bin" |
\     execute('silent !chmod +x <afile>') |
\   endif |
\ endif

" ----------------------------------------------------------------------
" -                   Reload (RC) files when saving.                   -
" ----------------------------------------------------------------------

" Reload vimrc files when saving a vimrc file.
au BufWritePost *.vim silent! source $MYVIMRC

" Reload conky when saving a conky-related file.
au BufWritePost ~/.conkyrc silent! !pkill -USR1 conky
au BufWritePost ~/.conky/lua/* silent! !pkill -USR1 conky

" Restart imwheel when saving .imwheelrc.
au BufWritePost ~/.imwheelrc silent! !~/bin/imwheelstart &> /dev/null

" Reload the tmux config when saving it.
au BufWritePost ~/.tmux.conf silent! !tmux source-file ~/.tmux.conf &> /dev/null
