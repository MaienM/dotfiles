" Part of my modulized vimrc file.
" Last change: Thu, 01 Jan 1970 01:00:00 +0100

let g:detectindent_preffered_expandtab = 0
let g:detectindent_preffered_indent = 4

au BufReadPost * :DetectIndent
