" Re-run last command.
nnoremap <Leader>RR :VimuxInterruptRunner<CR>:VimuxRunLastCommand<CR>

" Re-run a command from the shell history.
function! VimuxInterruptAndRun(command)
	call VimuxInterruptRunner()
	call VimuxRunCommand(a:command)
endfunction
function! VimuxRunZshLast()
	call VimuxInterruptAndRun(shell#lastcommand())
endfunction
function! VimuxRunZshList()
	call fzf#run(fzf#wrap({
		\'source': shell#commands(),
		\'sink': function('VimuxInterruptAndRun'),
	\}))
endfunction
nnoremap <Leader>RS :call VimuxRunZshLast()<CR>
nnoremap <Leader>Rs :call VimuxRunZshList()<CR>
