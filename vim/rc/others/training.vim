" Disable the arrow keys. It's time for me to man up and get used to using
" hjkl.
map <up> :echoerr "Don't use up, use k instead"<CR>
map <down> :echoerr "Don't use down, use j instead"<CR>
map <left> :echoerr "Don't use left, use h instead"<CR>
map <right> :echoerr "Don't use right, use l instead"<CR>
imap <up> <C-O><up>
imap <down> <C-O><down>
imap <left> <C-O><left>
imap <right> <C-O><right>
vmap <up> :<C-U>echoerr "Don't use up, use k instead"<CR>
vmap <down> :<C-U>echoerr "Don't use down, use j instead"<CR>
vmap <left> :<C-U>echoerr "Don't use left, use h instead"<CR>
vmap <right> :<C-U>echoerr "Don't use right, use l instead"<CR>

" Disable escape, to force myself to get used to using jj.
imap <Esc> <C-O>:echoerr "Don't use escape, use jj instead"<CR> 

" No more moving to spaces. There ae dedicated motions for this, use them!
map f<Space> :echoerr "Don't use f space, use El instead"<CR>
map F<Space> :echoerr "Don't use F space, use Bh instead"<CR>
map t<Space> :echoerr "Don't use t space, use E instead"<CR>
map T<Space> :echoerr "Don't use T space, use B instead"<CR>
