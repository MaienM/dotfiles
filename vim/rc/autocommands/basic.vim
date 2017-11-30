"
" Reading files.
"

" Jump to the position we were at when we exited.
au BufRead * :silent! normal `"

" Open all folds.
au BufRead * :normal zR

"
" Writing files.
"

" Make files that start with a shebang (#!...) executable.
" au BufWritePost * 
" \ if getline(1) =~ "^#!" |
" \   if getline(1) =~ "/bin" |
" \     execute('silent !chmod +x <afile>') |
" \     e! |
" \   endif |
" \ endif

" Reload vimrc files when saving a vimrc file.
au BufWritePost vimrc,*.vim silent! source $MYVIMRC
