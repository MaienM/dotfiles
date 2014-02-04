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

" Settings dependant on loaded files.
Bundle 'ciaranm/detectindent'
Bundle 'ciaranm/securemodelines'

" Easy commenting.
Bundle 'tpope/vim-commentary'

" Lists.
Bundle 'sjl/gundo.vim'
Bundle 'majutsushi/tagbar'
Bundle 'shougo/unite.vim'

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
Bundle 'sirver/ultiSnips'

" Tab complete.
Bundle 'ervandew/supertab'
Bundle 'shougo/neocomplcache'

" Syntax checks (lint, etc).
Bundle 'scrooloose/syntastic'

" Syntax highlighting.
Bundle 'beyondwords/vim-twig'

" Colorscheme.
Bundle 'altercation/vim-colors-solarized'

" Turn filetype back on.
filetype plugin indent on
