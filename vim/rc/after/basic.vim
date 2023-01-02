" Switch syntax highlighting on.
if &t_Co > 2 || has('gui_running')
	syntax on
endif

" Enable file type detection.
" Use the default filetype settings, so that mail gets 'tw' set to 72, 'cindent' is on in C files, etc.
" Also load indent files, to automatically do language-dependent indenting.
if has('autocmd')
	filetype plugin indent on
endif
