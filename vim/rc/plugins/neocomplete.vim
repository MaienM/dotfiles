if has('nvim')
	finish
endif

let g:neocomplete#enable_at_startup = 1
let g:neocomplete#enable_smart_case = 1

" Tab support.
inoremap <silent><expr><tab> pumvisible() ? "\<c-n>" : "\<tab>"
inoremap <silent><expr><s-tab> pumvisible() ? "\<c-p>" : "\<s-tab>"
