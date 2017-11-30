let g:syntastic_check_on_wq = 0
let g:syntastic_aggregate_errors = 1
let g:syntastic_auto_jump = 1
let g:syntastic_mode_map = { 'mode': 'passive' }
let g:syntastic_coffee_checkers = ['coffeelint', 'coffee']
let g:syntastic_cpp_compiler_options = ' -std=gnu++0x'
let g:syntastic_javascript_checkers=['eslint']
let g:syntastic_javascript_eslint_exe='$(npm bin)/eslint'
let g:syntastic_php_checkers = ['php', 'phpmd']
let g:syntastic_ruby_checkers = ['mri', 'rubocop']
" let g:syntastic_ruby_rubocop_exec = '$HOME/.rbenv/shims/rubocop'

" map <Leader>ss :SyntasticToggleMode<CR>
