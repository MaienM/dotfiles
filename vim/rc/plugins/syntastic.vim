" Part of my modulized vimrc file.
" Last change: Tue, 29 Jul 2014 21:52:43 +0200

let g:syntastic_check_on_wq = 0
let g:syntastic_aggregate_errors = 1
let g:syntastic_auto_jump = 1
let g:syntastic_mode_map = { 'mode': 'passive' }
let g:syntastic_cpp_compiler_options = ' -std=gnu++0x'
let g:syntastic_php_checkers=['php', 'phpmd']

map <Leader>s :SyntasticCheck<CR>
