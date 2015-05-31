" Part of my modulized vimrc file.
" Last change: Thu, 01 Jan 1970 01:00:00 +0100

" No linting, I use Syntastic for this.
let g:pymode_lint = 0

" No cache generation on write.
let g:pymode_rope_regenerate_on_write = 0
let g:pymode_rope_autoimport = 0

" STOP MESSING AROUND WITH MY FUCKING AUTOCOMPLETION YOU FUCKER.
let g:pymode_rope_completion = 0
let g:pymode_rope_complete_on_dot = 0
    
" I already have docs.
let g:pymode_doc = 0
