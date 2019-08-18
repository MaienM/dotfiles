function aleignore#types#NormalizeCommentDef(def)
	if type(a:def) == v:t_dict
		return a:def
	endif

	let def = copy(g:aleignore_commentdef_defaults)
	let def.text = a:def
	return def
endfunction

function aleignore#types#IsCommentDef(def)
	if type(a:def) == v:t_dict
		return has_key(a:def, 'text')
	endif
	return type(a:def) == v:t_string
endfunction

function! aleignore#types#NormalizeFormatDef(def)
	if type(a:def) == v:t_dict && !aleignore#types#IsCommentDef(a:def)
		return a:def
	endif
	return { 'inline': a:def }
endfunction

function! aleignore#types#IsFormatDef(def)
	if type(a:def) == v:t_dict
		return has_key(a:def, 'above') || has_key(a:def, 'inline') || has_key(a:def, 'below')
	endif
	return aleignore#types#IsCommentDef(a:def)
endfunction

function! aleignore#types#NormalizeLinterDef(def)
	if type(a:def) == v:t_dict && !aleignore#types#IsFormatDef(a:def)
		return a:def
	endif
	return { 'Default': a:def }
endfunction

