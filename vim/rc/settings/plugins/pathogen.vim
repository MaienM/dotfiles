" Part of my modulized vimrc file.
" Last change: Wed, 16 Mar 2011 19:54:10 +0100

" Add the pathogen path to the runtime path.
set runtimepath&
let &runtimepath = &runtimepath . ',' . finddir('repos/pathogen', &runtimepath)

" Start pathogen.
call pathogen#runtime_append_all_bundles() 
call pathogen#helptags()
