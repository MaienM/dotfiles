" Allow backspacing over everything in insert mode.
set backspace=indent,eol,start

function! Base16()
  if filereadable(expand("~/.vimrc_background"))
    source ~/.vimrc_background
  endif
endfunction
command Base16 :call Base16()<CR>

" Theme.
if &t_Co > 2 || has("gui_running")
  set t_Co=256
  set guioptions=0
  set background=dark
  let base16colorspace=256
  call Base16()
endif

" Font
if has("gui_running")
  set guifont=Inconsolata-dz\ for\ Powerline:h10
endif

" General settings.
set title                       " set the title of the window/terminal to 
                                " filename (path) - VIM
set history=100                 " keep 100 lines of command line history
set undolevels=2000             " have a big undo history
set incsearch                   " do incremental searching
set ignorecase smartcase        " ignore case when using a search pattern,
                                " except when upper case letters are used
set showcmd                     " display incomplete commands
set noexpandtab                 " default indent settings.
set tabstop=4                   "
set softtabstop=4               " <F6> can be used to easily change these 
set shiftwidth=4                "      settings on the fly. 
set autoindent                  " automatically indent
set smarttab                    " delete shiftwidth amount of spaces with <BS>
set linebreak                   " break long lines into pieces
set showbreak=>>\               " start continued lines with '>> '
set foldmethod=marker           " automatically fold
set foldnestmax=4               " don't fold more than 4 levels deep
set scrolloff=5                 " set the minium number of lines to keep 
                                " visible above/below the cursor
set listchars=tab:>-,trail:-    " make displaying tabs look like >---
set wildignore=*~               " ignore certain files when tab-completing
set tags+=./tags;               " search upwards from the current directory for 
set tags+=./TAGS;               " tag files
set splitright                  " when vertically splitting, open new stuff at
                                " the right side instead of at the left side
set wildmode=longest,list,full  " bash-like completion
set wildmenu                    " ^^^
set tabpagemax=25
set number relativenumber       " there be numbers, mon
set exrc                        " basic per-project config file
set noswapfile                  " no swap files
set ttimeoutlen=50              " make it more snappy
set wrap                        " fuck sidescrolling
set bufhidden=hide              " lemme switch buffers without saving

" don't clutter $PWD
if has("win32") || has("win16")
  let s:pathsep = '\\\\'
else
  let s:pathsep = '/'
endif
let s:cache_basedir = $HOME . s:pathsep . '.cache' . s:pathsep . 'vim'
call mkdir(s:cache_basedir . s:pathsep . 'backup', 'p')
call mkdir(s:cache_basedir . s:pathsep . 'swap', 'p')
call mkdir(s:cache_basedir . s:pathsep . 'undo', 'p')
let &backupdir=s:cache_basedir . s:pathsep . 'backup//'
let &directory=s:cache_basedir . s:pathsep . 'swap//'

" Version-specific stuff, doesn't work in older versions, sadly.
if v:version >= 600
  set clipboard=unnamed        " interoperate with the X clipboard
endif

if v:version >= 700
  set spelllang=en,nl          " spell-check both english and dutch, for the
                               " rare moments I use Dutch (as if)
endif

" Vim 7.3+
if has("persistent_undo")
  set undofile                  " enable persistent undo
  " but don't clutter $PWD
  let &undodir=s:cache_basedir . s:pathsep . 'undo//'
endif

" In many terminal emulators the mouse works just fine, thus enable it.
if has('mouse')
  set mouse=a
endif
set mouse=

" Switch syntax highlighting on, when the terminal has colors
" Also switch on highlighting the last used search pattern.
if &t_Co > 2 || has("gui_running")
  syntax on
  set hlsearch
  noh " Clear highlight. Without this reloading the vimrc file rehighlights the
      " last search.
endif

" Only do this part when compiled with support for autocommands.
if has("autocmd")
  " Enable file type detection.
  " Use the default filetype settings, so that mail gets 'tw' set to 72,
  " 'cindent' is on in C files, etc.
  " Also load indent files, to automatically do language-dependent indenting.
  filetype plugin indent on

  " For all text files set 'textwidth' to 78 characters.
  autocmd FileType text setlocal textwidth=78
else
  set autoindent    " always set autoindenting on
endif " has("autocmd")

