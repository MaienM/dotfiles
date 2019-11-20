function! s:ProcessLine(line)
	return substitute(a:line, '^[^;]*;', '', '')
endfunction

function! s:ReadHistFile()
	return reverse(readfile($HOME . '/.zhistory'))
endfunction

function! shell#commands()
	let l:lines = s:ReadHistFile()
	return map(l:lines, {idx, line -> s:ProcessLine(line)})
endfunction

function! shell#lastcommand()
	let l:lines = s:ReadHistFile()
	return s:ProcessLine(l:lines[0])
endfunction
