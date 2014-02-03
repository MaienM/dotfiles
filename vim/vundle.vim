" Part of my modulized vimrc file.
" Last change: Thu, 15 Aug 2013 23:13:47 +0200

" Use Vim settings, rather then Vi settings (much better!).
" This must be first, because it changes other options as a side effect.
set nocompatible

" Filetype off.
filetype off

" Add the vundle path to the runtime path.
let &runtimepath = &runtimepath . ',' . finddir('bundle/vundle', &runtimepath)

" Start vundle.
call vundle#rc()

" Load vundle.
Bundle 'gmarik/vundle'

" Load all bundles.
Bundle 'tpope/vim-commentary'
Bundle 'ciaranm/detectindent'
Bundle 'sjl/gundo.vim'
Bundle 'nathanaelkane/vim-indent-guides'
Bundle 'tsaleh/vim-matchit'
Bundle 'Shougo/neocomplcache'
Bundle 'kien/rainbow_parentheses.vim'
Bundle 'tpope/vim-repeat'
Bundle 'ciaranm/securemodelines'
Bundle 'rstacruz/sparkup', {'rtp': 'vim/'}
Bundle 'ervandew/supertab'
Bundle 'tpope/vim-surround'
Bundle 'scrooloose/syntastic'
Bundle 'godlygeek/tabular'
Bundle 'majutsushi/tagbar'
Bundle 'beyondwords/vim-twig'
Bundle 'UltiSnips'
Bundle 'unite.vim'
Bundle 'altercation/vim-colors-solarized'

" Turn filetype back on.
filetype plugin indent on
