" Re-run last command.
nnoremap <Leader>RR :VimuxInterruptRunner<CR>:VimuxRunLastCommand<CR>

" Re-run a command from the shell history.
function! VimuxInterruptAndRun(command)
	call VimuxInterruptRunner()
	call VimuxRunCommand(a:command)
endfunction
function! VimuxRunZshLast()
	let l:lines = readfile($HOME . '/.zhistory')
	let l:lines = l:lines[-25:]
	let l:command = substitute(l:lines, '^[^;]*;', '', '')
	call VimuxInterruptAndRun(l:command)
endfunction
function! VimuxRunZshList()
	call fzf#run(fzf#wrap({
		\'source': 'cut -d";" -f2- < ~/.zhistory | tac',
		\'sink': function('VimuxInterruptAndRun'),
	\}))
endfunction
nnoremap <Leader>RS :call VimuxRunZshLast()<CR>
nnoremap <Leader>Rs :call VimuxRunZshList()<CR>
