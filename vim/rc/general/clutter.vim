" Don't clutter $PWD with vim specific files, store them in ~/.cache instead.
if has('win32') || has('win16')
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

" Disable swapfiles and backup files altogether.
set nobackup
set noswapfile

" Enable persistent undo.
if has('persistent_undo')
	set undofile
	" Like above, don't clutter $PWD.
	let &undodir=s:cache_basedir . s:pathsep . 'undo//'
endif
