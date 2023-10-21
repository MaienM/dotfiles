if has('nvim')
	finish
endif

nmap <Leader>tc :TestNearest<CR>
nmap <Leader>tf :TestFile<CR>
nmap <Leader>ta :TestSuite<CR>
nmap <Leader>tt :TestLast<CR>
nmap <Leader>gt :TestVisit<CR>

if exists('g:gui_oni')
	let test#strategy = 'neovim'
else
	let test#strategy = 'vimux'
endif
