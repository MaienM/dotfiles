" Part of my modulized vimrc file.
" Last change: Sun, 02 Oct 2011 19:15:22 +0200

" Add the pathogen path to the runtime path.
set runtimepath&
let &runtimepath = &runtimepath . ',' . finddir('bundle/pathogen', &runtimepath)

" Start pathogen.
call pathogen#infect()
Helptags

