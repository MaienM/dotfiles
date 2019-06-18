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

" Re-apply the colorscheme. Without doing this, re-loading the vimrc during runtime causes some of the colors to be
" messed up.
function! s:FixColorscheme(timer)
	try
		let l:colorscheme = g:colors_name
	catch /^Vim:E121/
		let l:colorscheme = 'default'
	endtry
	exe 'colorscheme ' . l:colorscheme
endfunction
au BufWritePost * let timer = timer_start(1, funcref('<SID>FixColorscheme'))
