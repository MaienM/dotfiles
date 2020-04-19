" Some settings for git buffers.
au FileType gitcommit call s:settings()
function! s:settings()
	" No folding.
	setlocal nofoldenable

	" So I can spam C-C to get out, now.
	nmap <buffer> <C-C> :<C-U>q<CR>
endfunction

nnoremap <Leader>vg :Gstatus<CR>
