if !has('nvim')
	finish
end

let g:deoplete#enable_at_startup = 1
let g:deoplete#enable_smart_case = 1

"call deoplete#custom#set('ultisnips', 'matchers', ['matcher_fuzzy'])

" Tab support
inoremap <silent><expr><tab> pumvisible() ? "\<c-n>" : "\<tab>"
inoremap <silent><expr><s-tab> pumvisible() ? "\<c-p>" : "\<s-tab>"
