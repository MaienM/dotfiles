" Part of my modulized vimrc file.
" Last change: 

" Jump to the position we were at when we exited.
au BufRead * '"

" Open all folds.
au BufRead * :normal zR

" Set the filetype to asm for casm files.
au BufRead *.casm set ft=asm

