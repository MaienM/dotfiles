" Part of my modulized vimrc file.
" Last change: 

" Use Vim settings, rather then Vi settings (much better!).
" This must be first, because it changes other options as a side effect.
set nocompatible

" Filetype off.
filetype off

" Determine the path to neobundle.
let s:vimdir_path = fnamemodify(resolve(expand('<sfile>:p')), ':h')
let s:neobundle_path = s:vimdir_path . '/bundle/neobundle.vim'

" Download neobundle if it does not exists.
if !isdirectory(s:neobundle_path)
	echom "Your plugins seem to be missing, installing them now. This may take a while, and you need to relaunch vim after this."
    let s:first_run = 1
    call delete(s:vimdir_path . '/.VimballRecord')
    silent! execute '!git clone https://github.com/Shougo/neobundle.vim.git ' . s:neobundle_path
else
    let s:first_run = 0
endif

" Load neobundle.
let &runtimepath = &runtimepath . ',' . s:neobundle_path
call neobundle#rc(s:vimdir_path . '/bundle')
NeoBundle 'Shougo/neobundle.vim'

" Vimproc.
NeoBundle 'Shougo/vimproc', {
    \'build': {
		\'windows': 'make -f make_msvc.mak',
		\'unix': 'make -f make_unix.mak',
    \},
\}

" Settings dependant on loaded files.
NeoBundle 'ciaranm/detectindent'
NeoBundle 'ciaranm/securemodelines'

" Easy commenting.
NeoBundle 'tpope/vim-commentary'

" Information lists.
NeoBundle 'sjl/gundo.vim'
NeoBundle 'majutsushi/tagbar'
NeoBundle 'Shougo/unite.vim'

" Visual clues.
NeoBundle 'nathanaelkane/vim-indent-guides'
NeoBundle 'kien/rainbow_parentheses.vim'

" Movement.
NeoBundle 'justinmk/vim-sneak'
NeoBundle 'vim-scripts/matchit.zip'
NeoBundle 'bkad/CamelCaseMotion'

" Editing.
NeoBundle 'tpope/vim-repeat'
NeoBundle 'tpope/vim-surround'
NeoBundle 'tpope/vim-abolish'
NeoBundle 'tpope/vim-speeddating'
NeoBundle 'godlygeek/tabular'
NeoBundle 'mattn/emmet-vim'
NeoBundle 'AndrewRadev/splitjoin.vim'

" Snippets.
NeoBundle 'SirVer/ultisnips'

" Tab complete.
"NeoBundle 'ervandew/supertab'
"NeoBundle 'Shougo/neocomplcache'
NeoBundle 'Valloric/YouCompleteMe', {
	\'build' : {
		\'unix' : './install.sh --clang-completer --omnisharp-completer',
    \},
\}

" Syntax checks (lint, etc).
NeoBundle 'scrooloose/syntastic'

" Syntax highlighting.
NeoBundle 'beyondwords/vim-twig'
NeoBundle 'vim-scripts/nginx.vim'

" Colorscheme.
NeoBundle 'altercation/vim-colors-solarized'

" If this is the first run (that is, if we had to download neobundle), download
" all bundles.
if s:first_run
    NeoBundleInstall
endif

" Powerline.
set rtp+=$POWERLINE_REPO/powerline/bindings/vim

" Turn filetype back on.
filetype plugin indent on
