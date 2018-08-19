" Enable by default.
let g:indent_guides_enable_on_vim_startup=1

" Colors that work with base16
let g:indent_guides_auto_colors = 0
au VimEnter,Colorscheme * :hi IndentGuidesOdd  guibg=base01 ctermbg=18
au VimEnter,Colorscheme * :hi IndentGuidesEven guibg=base02 ctermbg=19

" Exclude filetypes
let g:indent_guides_exclude_filetypes = ['help', 'fzf']
