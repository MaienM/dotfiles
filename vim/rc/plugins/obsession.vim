" Load existing session
if filereadable('.lvim/Session.vim')
	source .lvim/Session.vim
endif

" Re-start obsession
if isdirectory('.lvim')
	call timer_start(2000, { tid -> execute('Obsession .lvim/') })
endif
