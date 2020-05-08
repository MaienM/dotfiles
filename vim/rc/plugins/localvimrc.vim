" Remember choices if given in uppercase.
let g:localvimrc_persistent = 1

" Use a directory for vim stuff.
let g:localvimrc_name = ['.lvim/init.vim', '.lvimrc']

" Load on BufRead. This is earlier than default, allowing modelines to overwrite the localvimrc settings.
" let g:localvimrc_event = ["BufRead"]
