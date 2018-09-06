" Some commonly mistyped commands.
command! W :w
command! Q :q
command! WQ :wq
command! Wq :wq

" Create/open a file in the same directory as the current file.
command! -bang -nargs=? Sibling exe ':e<bang> ' . expand('%:h') . '/' . <q-args>
