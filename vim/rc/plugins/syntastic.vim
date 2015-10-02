" Part of my modulized vimrc file.
" Last change: Thu, 31 Jul 2014 19:59:41 +0200

let g:syntastic_check_on_wq = 0
let g:syntastic_aggregate_errors = 1
let g:syntastic_auto_jump = 1
let g:syntastic_mode_map = { 'mode': 'passive' }
let g:syntastic_coffee_checkers = ['coffeelint', 'coffee']
let g:syntastic_cpp_compiler_options = ' -std=gnu++0x'
let g:syntastic_php_checkers = ['php', 'phpmd']

map <Leader>ss :SyntasticToggleMode<CR>
