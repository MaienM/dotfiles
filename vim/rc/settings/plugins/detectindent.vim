" Part of my modulized vimrc file.
" Last change: Sat, 18 May 2013 12:02:54 +0200

let g:detectindent_preffered_expandtab = 0
let g:detectindent_preffered_indent = 4

au BufReadPost * :DetectIndent
