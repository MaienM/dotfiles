" Part of my modulized vimrc file.
" Last change: Thu, 01 Jan 1970 01:00:00 +0100

" Use Vim settings, rather then Vi settings (much better!).
" This must be first, because it changes other options as a side effect.
set nocompatible

" Load pathogen.
" This too had to happen before anything else, so we can be sure that all
" plugins and such are available for use in the vimrc files.

" Add the pathogen path to the runtime path.
set runtimepath&
let &runtimepath = &runtimepath . ',' . finddir('bundle/pathogen', &runtimepath)

" Start pathogen.
call pathogen#infect()
Helptags

" Load the rc files responsible for the rest of the initialisation.
runtime! rc/**.vim
