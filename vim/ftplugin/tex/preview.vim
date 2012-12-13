" Part of my modulized vimrc file.
" Last change: Thu, 01 Jan 1970 01:00:00 +0100

command! -b Preview call ShellIfExists(expand('%:p:r').'.pdf', 'zathura --fork \"'.expand('%:p:r').'.pdf\"', 0)
