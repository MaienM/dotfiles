" Re-run last command
nnoremap <Leader>RR :VimuxInterruptRunner<CR>:VimuxRunLastCommand<CR>

" Re-run the last command executed in the shell
function! VimuxRunLastZsh()
	let l:lines = readfile($HOME . '/.zhistory')
	let l:line = l:lines[len(l:lines) - 1]
	let l:command = substitute(l:line, '^[^;]*;', '', '')

	call VimuxInterruptRunner()
	call VimuxRunCommand(l:command)
endfunction
nnoremap <Leader>RS :call VimuxRunLastZsh()<CR>
