" Check on insert mode leave instead of during typing.
let g:ale_lint_on_text_changed = 'normal'
let g:ale_lint_on_insert_leave = 1

" Mappings. <Leader>s for sign related stuff, and <Leader>c for codestyle stuff.
map <Leader>ss :ALEToggle<CR>
map <Leader>cn :ALENextWrap<CR>
map <Leader>cp :ALEPreviousWrap<CR>
map <Leader>cg :ALEFirst<CR>
map <Leader>cG :ALELast<CR>
map <Leader>cf :ALEFix<CR>
map <Leader>ci :ALEIgnore<CR>

" Enable fixing on command for javascript.
let g:ale_fixers = {
	\'javascript': ['eslint'],
\}

