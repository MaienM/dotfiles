" Part of my modulized vimrc file.
" Last change: Thu, 01 Jan 1970 01:00:00 +0100

if !has('nvim')
	finish
end

let g:deoplete#enable_at_startup = 1
let g:deoplete#enable_smart_case = 1

call deoplete#custom#set('ultisnips', 'matchers', ['matcher_fuzzy'])
