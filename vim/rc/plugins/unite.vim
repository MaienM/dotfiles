let g:split_rule = 'bottomleft'

" Buffer switching.
map <Leader>b :Unite buffer<CR>

" Keep no-file buffers (which are usually previews or something like that) out
" of the buffer list.
au BufLeave if &buftype ==# "nofile" | setlocal bufhidden=wipe | endif
