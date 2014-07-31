" Part of my modulized vimrc file.
" Last change: 

" Allow backspacing over everything in insert mode.
set backspace=indent,eol,start

" Theme.
if &t_Co > 2
  set t_Co=256
  set background=dark
  colorscheme solarized
  "colorscheme herald
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
set relativenumber              " there be numbers, mon
set exrc                        " basic per-project config file
set noswapfile                  " no swap files
set ttimeoutlen=50              " make it more snappy
set backupdir=$TEMP//,$TMP//,.  " don't clutter $PWD

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
  let &undodir=&backupdir       " but don't clutter $PWD
endif

" In many terminal emulators the mouse works just fine, thus enable it.
if has('mouse')
  set mouse=a
endif

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

