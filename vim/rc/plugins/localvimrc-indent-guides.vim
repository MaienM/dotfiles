" Part of my modulized vimrc file.
" Last change: Thu, 01 Jan 1970 01:00:00 +0100

if &rtp !~ ".*indent-guides.*"
	finish
endif

" After loading the file, reapply the indent guides
au User LocalVimRCPost * :IndentGuidesEnable<CR>
