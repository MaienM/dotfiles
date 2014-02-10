" Part of my modulized vimrc file.
" Last change: 

" Use Vim settings, rather then Vi settings (much better!).
" This must be first, because it changes other options as a side effect.
set nocompatible

" Filetype off.
filetype off

" Determine the path to vundle.
let s:vimdir_path = fnamemodify(resolve(expand('<sfile>:p')), ':h')
let s:vundle_path = s:vimdir_path . '/bundle/vundle'

" Download vundle if it does not exists.
if !isdirectory(s:vundle_path)
	echom "Your plugins seem to be missing, installing them now.\n This may take a while, and you need to relaunch vim after this."
    let s:first_run = 1
    call delete(s:vimdir_path . '/.VimballRecord')
    silent! execute '!git clone git://github.com/gmarik/vundle.git ' . s:vundle_path
else
    let s:first_run = 0
endif

" Load vundle.
let &runtimepath = &runtimepath . ',' . s:vundle_path
call vundle#rc(s:vimdir_path . '/bundle')
Bundle 'gmarik/vundle'

" Settings dependant on loaded files.
Bundle 'ciaranm/detectindent'
Bundle 'ciaranm/securemodelines'

" Easy commenting.
Bundle 'tpope/vim-commentary'

" Lists.
Bundle 'sjl/gundo.vim'
Bundle 'majutsushi/tagbar'
Bundle 'Shougo/unite.vim'

" Visual clues.
Bundle 'nathanaelkane/vim-indent-guides'
Bundle 'kien/rainbow_parentheses.vim'

" Movement.
Bundle 'justinmk/vim-sneak'
Bundle 'tsaleh/vim-matchit'

" Editing.
Bundle 'tpope/vim-repeat'
Bundle 'tpope/vim-surround'
Bundle 'tpope/vim-abolish'
Bundle 'tpope/vim-speeddating'
Bundle 'godlygeek/tabular'
Bundle 'mattn/emmet-vim'

" Snippets.
Bundle 'SirVer/ultisnips'

" Tab complete.
Bundle 'ervandew/supertab'
Bundle 'Shougo/neocomplcache'

" Syntax checks (lint, etc).
Bundle 'scrooloose/syntastic'

" Syntax highlighting.
Bundle 'beyondwords/vim-twig'

" Colorscheme.
Bundle 'altercation/vim-colors-solarized'

" If this is the first run (that is, if we had to download vundle), download
" all bundles.
if s:first_run
    BundleInstall
endif

" Turn filetype back on.
filetype plugin indent on
