" Part of my modulized vimrc file.
" Last change: Thu, 01 Jan 1970 01:00:00 +0100

" Force all commands to go through our code so we can log the last command,
" and we can use something else than normal
function! UseCaller(caller)
endfunction

" Re-run last dispatch command in vimux.
function! VimuxRunLastDispatch()
	normal m"
	Dispatch --
	let req = g:dispatch_last_request
	call VimuxRunCommand('cd "' . req.directory . '" && ' . req.command)
	normal '"
endfunction

nnoremap <Leader>Rr :call VimuxRunLastDispatch()<CR>
