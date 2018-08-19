" Allow backspacing over everything in insert mode.
set backspace=indent,eol,start

" Set the title of the window/terminal.
set title

" Increase the size of the various histories.
set history=10000
set undolevels=10000

" Display incomplete keystrokes. Eg, between pressing d and following it up with a motion, 'd' will be shown.
set showcmd

" Set the minium number of lines to keep visible above/below the cursor.
set scrolloff=5

" Split vertically by default. When doing so, open new stuff at the right side instead of at the left side.
set diffopt+=vertical
set splitright

" Show relative line numbers, except for the current line, where the absolute line number is shown.
set number
set relativenumber

" Allow switching to another buffer without saving first.
set hidden
set bufhidden=hide

" Decent preview window height.
set previewheight=20

" Tab completion in commands.
set wildmenu
set wildmode=longest,list,full

" Default to folding by marker. If a filetype has support for syntax, it should set this.
set foldmethod=marker
set foldnestmax=4

" Show certain invisible characters. Only used when 'list' is enabled, which it is not by default.
set listchars=tab:>-,trail:-

" Store globals in the session, which includes stuff like last ran vimux command.
set sessionoptions+=globals
" Don't store options in the session, as this also includes stuff like the runtimepath, which will mess with changed
" plugins.
set sessionoptions-=options

" Setup search behavior: incremental, and case-insensitive unless uppercase is used.
set incsearch
set ignorecase
set smartcase

" Default indent settings.
set noexpandtab
set tabstop=3
set softtabstop=3
set shiftwidth=3

" (Mostly) sensible indent behavior.
set autoindent
set smarttab

" Break lines automatically at textwidth.
set textwidth=120
set linebreak

" Wrap long lines to prevent horizontal scrolling, and show this visually.
set wrap
let &showbreak = '>> '

" Use the pyenv environment prepared by the install script.
let g:python_host_prog = $HOME . '/.pyenv/versions/neovim2/bin/python'
let g:python3_host_prog = $HOME . '/.pyenv/versions/neovim3/bin/python'

" Use the X clipboard if possible.
if v:version >= 600
	set clipboard=unnamed
endif

" Spell-check both English and Dutch.
if v:version >= 700
	set spelllang=en,nl         
endif

" Switch syntax highlighting on.
if &t_Co > 2 || has('gui_running')
	syntax on
endif

" Enable file type detection.
" Use the default filetype settings, so that mail gets 'tw' set to 72, 'cindent' is on in C files, etc.
" Also load indent files, to automatically do language-dependent indenting.
if has('autocmd')
	filetype plugin indent on
endif
