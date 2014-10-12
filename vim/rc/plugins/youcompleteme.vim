" Part of my modulized vimrc file.
" Last change: Sun, 24 Aug 2014 16:56:47 +0200

" Use Youcompleteme's GoTo command instead of C-] for supported languages.
au FileType c,cpp,objc,objcpp,python,cs nnoremap <C-]> :YcmCompleter GoTo<CR>

let g:ycm_autoclose_preview_window_after_insertion = 1
