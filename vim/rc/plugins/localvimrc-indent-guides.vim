if &rtp !~ '.*indent-guides.*'
	finish
endif

" After loading the file, reapply the indent guides.
if !has('nvim')
	au User LocalVimRCPost :IndentGuidesEnable
endif
