" Part of my modulized vimrc file.
" Last change: Thu, 01 Jan 1970 01:00:00 +0100

command! W :w
command! Q :q
command! WQ :wq
command! Wsudo w !sudo tee > /dev/null %
