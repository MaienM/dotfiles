" Part of my modulized vimrc file.
" Last change: Wed, 16 Mar 2011 15:40:02 +0100

" Update the first timestamp found in the top 10 lines of a file.
if exists("*strftime")
  au BufWrite * mark ' | silent! 0,/\%<11l/call UpdateTimestamp() | ''
endif

" Make files that start with a shebang (#!...) executable.
au BufWritePost * 
\ if getline(1) =~ "^#!" |
\   if getline(1) =~ "/bin" |
\     execute('silent !chmod +x <afile>') |
\   endif |
\ endif

" Warn me when saving an userscript with an improper version.
au BufWrite *.js silent! 
\ if search('@version', 'n') != 0 |
\   if search('@version\s\+\([0-9.]\+\)\_.*changelog.*\n.*version \1$', 'n') == 0 |
\     echoerr "The version of the script seems to be incorrect." |
\     exe 'normal \<Esc' |
\   endif |
\ endif

" ----------------------------------------------------------------------
" -                   Reload (RC) files when saving.                   -
" ----------------------------------------------------------------------

" Reload vimrc files when saving a vimrc file.
au BufWritePost *.vim normal \rl

" Reload conky when saving a conky-related file.
au BufWritePost ~/.conkyrc silent! !pkill -USR1 conky
au BufWritePost ~/.conky/lua/* silent! !pkill -USR1 conky

" Restart imwheel when saving .imwheelrc.
au BufWritePost ~/.imwheelrc silent! !~/bin/imwheelstart &> /dev/null

" Reload the tmux config when saving it.
au BufWritePost ~/.tmux.conf silent! !tmux source-file ~/.tmux.conf

" Scss files.
au BufWritePost *.sass silent! !sass --style compressed --update <afile> &> /dev/null
au BufWritePost *.scss silent! !sass --scss --style compressed --update <afile> &> /dev/null
