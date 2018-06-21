"
" Reading files.
"

" Jump to the position we were at when we exited.
au BufRead * :silent! normal `"

"
" Writing files.
"

" Reload vimrc files when saving a vimrc file.
au BufWritePost vimrc,*.vim silent! source $MYVIMRC
