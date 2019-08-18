function! aleignore#ALEIgnore()
	if !exists('*ale#list#GetCombinedList')
		echoe "ALE not found, cannot continue."
		return
	endif
	if !exists('*fzf#run')
		echoe "FZF not found, cannot continue."
		return
	endif
	if !exists('*tcomment#Comment')
		echoe "TComment not found, cannot continue."
		return
	endif

	" Group the errors by the linter that reported them.
	let errors = ale#list#GetCombinedList()
	let s:by_linter = {}
	for error in errors
		if error.lnum == line('.')
			let linter = error.linter_name
			if has_key(s:by_linter, error.linter_name) == 0
				let s:by_linter[linter] = []
			endif
			let s:by_linter[error.linter_name] += [error]
		endif
	endfor
	call s:ALEIgnoreChooseLinter()
endfunction

function! s:ALEIgnoreChooseLinter()
	let linters = keys(s:by_linter)
	if len(linters) == 0
		echom "Nothing to ignore."
		return
	elseif len(linters) == 1
		call s:ALEIgnoreChooseErrors(linters[0])
	else
		call fzf#run({ 
			\'source': linters,
			\'sink': function('<SID>ALEIgnoreChooseErrors'),
		\})
	end
endfunction

function! s:ALEIgnoreChooseErrors(linter)
	let s:linter = a:linter
	let errors = s:by_linter[a:linter]
	let errors = map(errors, {i, error -> error.code . ' ' . trim(error.text)})

	if len(errors) == 0
		echoe "The chosen linter had no errors (this should never happen)."
		return
	elseif len(errors) == 1
		call s:ALEIgnoreChooseFormat(errors)
	else
		call fzf#run({ 
			\'source': errors,
			\'sink*': function('<SID>ALEIgnoreChooseFormat'),
			\'options': '--multi',
		\})
	endif
endfunction

function! s:ALEIgnoreChooseFormat(errors)
	let errors = map(a:errors, {i, error -> split(error, ' ')[0]})

	if has_key(g:aleignore_rules, s:linter)
		let linterdef = g:aleignore_rules[s:linter](errors)
	else
		let linterdef = g:Aleignore_fallback(l:linter, errors)
	endif
	let linterdef = aleignore#types#NormalizeLinterDef(linterdef)

	let s:formats = {}
	let options = []
	for [name, formatdef] in items(linterdef)
		let formatdef = aleignore#types#NormalizeFormatDef(formatdef)
		let formatdef = map(formatdef, {name, commentdef -> aleignore#types#NormalizeCommentDef(commentdef)})
		let s:formats[name] = formatdef
		let options += [base64#encode(aleignore#preview#FormatDef(formatdef)) . ' ' . name]
	endfor 

	if len(options) == 0
		echoe "No output formats found for the chosen linter (this should never happen)."
		return
	elseif len(options) == 1
		call s:ALEIgnorePerform(options[0])
	else
		call fzf#run({ 
			\'source': options,
			\'sink': function('<SID>ALEIgnorePerform'),
			\'options': [
				\'--with-nth', '2..',
				\'--preview', 
					\'printf "%s\n\n" "Preview is only an indication, actual end result may deviate slightly.";' .
					\'echo {1} | base64 -d',
				\'--preview-window', 'up:50%',
				\'--bind', '?:toggle-preview',
			\],
		\})
	endif
endfunction

function! s:InsertCommentedLine(relativelinenr, commentdef)
	let linenr = line('.') + a:relativelinenr
	let commentdef = aleignore#types#NormalizeCommentDef(a:commentdef)
	let indent = split(getline('.'), '\S')[0]
	call append(linenr, indent . commentdef.text)
	call tcomment#Comment(linenr + 1, linenr + 1, 'mode=' . commentdef.style)
endfunction

function! s:ALEIgnorePerform(line)
	let parts = split(a:line, ' ')
	let formatname = parts[1]
	let formatdef = s:formats[formatname]

	if has_key(formatdef, 'above')
		call s:InsertCommentedLine(-1, formatdef.above)
	endif

	if has_key(formatdef, 'inline')
		call s:InsertCommentedLine(0, formatdef.inline)
		join
	endif

	if has_key(formatdef, 'below')
		call s:InsertCommentedLine(0, formatdef.below)
	endif
endfunction

