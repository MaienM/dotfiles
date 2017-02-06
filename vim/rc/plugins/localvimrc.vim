" Part of my modulized vimrc file.
" Last change: Thu, 01 Jan 1970 01:00:00 +0100

" Remember choices if given in uppercase
let g:localvimrc_persistent = 1

" After loading the file, reapply the indent guides
au User LocalVimRCPost * :IndentGuidesEnable<CR>
