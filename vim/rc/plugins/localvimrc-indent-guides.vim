if &rtp !~ '.*indent-guides.*'
	finish
endif

" After loading the file, reapply the indent guides.
au User LocalVimRCPost :IndentGuidesEnable
