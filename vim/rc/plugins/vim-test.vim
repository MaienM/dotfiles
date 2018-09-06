nmap <Leader>tt :TestNearest<CR>
nmap <Leader>tf :TestFile<CR>
nmap <Leader>ts :TestSuite<CR>
nmap <Leader>tr :TestLast<CR>
nmap <Leader>gt :TestVisit<CR>

if exists('g:gui_oni')
	let test#strategy = 'neovim'
else
	let test#strategy = 'vimux'
endif
