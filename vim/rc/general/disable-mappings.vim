" Built-in mappings that I don't want to use, but only ever trigger accidentally.
map <F1> <nop>
nmap q: <nop>
map <S-K> <nop>

" Don't use the arrow keys, use hjkl instead.
map <up> <nop>
map <down> <nop>
map <left> <nop>
map <right> <nop>
imap <up> <nop>
imap <down> <nop>
imap <left> <nop>
imap <right> <nop>

" No more moving to spaces. There are dedicated motions for this, use them!
map f<Space> :echoerr "Don't use f space, use El instead"<CR>
map F<Space> :echoerr "Don't use F space, use Bh instead"<CR>
map t<Space> :echoerr "Don't use t space, use E instead"<CR>
map T<Space> :echoerr "Don't use T space, use B instead"<CR>
