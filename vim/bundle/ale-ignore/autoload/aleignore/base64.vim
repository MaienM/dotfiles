function! s:GetCommands()
	if executable('base64')
		return { 'encode': 'base64', 'decode': 'base64 -d' }
	elseif executable('openssl')
		return { 'encode': 'openssl base64', 'decode': 'openssl base64 -d' }
	elseif executable('python')
		return { 'encode': 'python -m base64', 'decode': 'python -m base64 -d' }
	else
		echoe 'Unable to find a suitable base64 command.'
		return {}
	endif
endfunction

function! aleignore#base64#GetCommands()
	if !exists('s:commands')
		let s:commands = s:GetCommands()
	endif
	return s:commands
endfunction

function! s:DoAction(action, input)
	let commands = aleignore#base64#GetCommands()
	let result = system(commands[a:action], a:input)
	return substitute(result, '\n*$', '', '')
endfunction

function! aleignore#base64#Encode(input)
	return s:DoAction('encode', a:input)
endfunction

function! aleignore#base64#Decode(input)
	return s:DoAction('decode', a:input)
endfunction

