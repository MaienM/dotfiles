" Part of my modulized vimrc file.
" Last change: Mon, 14 Mar 2011 22:14:58 +0100


" Update the first timestamp found in the top 10 lines of a file.
if exists("*strftime")
  au BufWrite * mark ' | silent! 1,10call UpdateTimestamp() | ''
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

" Reload vimrc files when saving a vimrc file.
au BufWritePost *.vim normal \r

