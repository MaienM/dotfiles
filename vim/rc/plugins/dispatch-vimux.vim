" Re-run last dispatch command in vimux.
function! VimuxRunLastDispatch()
	normal m"
	Dispatch --
	let req = g:dispatch_last_request
	call VimuxRunCommand('cd "' . req.directory . '" && ' . req.command)
	normal '"
endfunction
nnoremap <Leader>Rr :call VimuxRunLastDispatch()<CR>
