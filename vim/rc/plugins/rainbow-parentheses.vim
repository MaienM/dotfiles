let g:rainbow#max_level = 16
let g:rainbow#pairs = [['(', ')'], ['[', ']'], ['{', '}']]
let g:rainbow#blacklist = [3, 6, 15]

au FileType * if exists('RainbowParentheses') | RainbowParentheses | endif
au VimEnter * if &ft != '' | :RainbowParentheses | endif
