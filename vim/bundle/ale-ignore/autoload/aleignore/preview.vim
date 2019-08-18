function! aleignore#preview#CommentDef(def)
	let def = aleignore#types#NormalizeCommentDef(a:def)
	let commentstring = tcomment#commentdef#Get('.', '.', def.style).commentstring
	return substitute(printf(commentstring, ' ' . def.text . ' '), '  ', ' ', '')
endfunction

function! aleignore#preview#FormatDef(def)
	let def = aleignore#types#NormalizeFormatDef(a:def)
	let lines = []

	if has_key(def, 'above')
		let lines += [aleignore#preview#CommentDef(def.above)]
	endif

	let midline = substitute(getline('.'), '^\s*', '', '')
	if has_key(def, 'inline')
		let midline = midline . ' ' . aleignore#preview#CommentDef(def.inline)
	endif
	let lines += [midline]

	if has_key(def, 'below')
		let lines += [aleignore#preview#CommentDef(def.below)]
	endif

	return join(lines, "\n")
endfunction

