" Part of my modulized vimrc file.
" Last change: Thu, 01 Jan 1970 01:00:00 +0100

" Check on insert mode leave instead of during typing
let g:ale_lint_on_text_changed = 'normal'
let g:ale_lint_on_insert_leave = 1

map <Leader>ss :ALEToggle<CR>
