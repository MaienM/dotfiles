" Write as sudo.
command! Wsudo w !sudo tee > /dev/null %

" Some commonly mistyped commands.
command! W :w
command! Q :q
command! WQ :wq
command! Wq :wq
