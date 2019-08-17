" Check on insert mode leave instead of during typing.
let g:ale_lint_on_text_changed = 'normal'
let g:ale_lint_on_insert_leave = 1

" Mappings. <Leader>s for sign related stuff, and <Leader>c for codestyle stuff.
map <Leader>ss :ALEToggle<CR>
map <Leader>cn :ALENextWrap<CR>
map <Leader>cp :ALEPreviousWrap<CR>
map <Leader>cg :ALEFirst<CR>
map <Leader>cG :ALELast<CR>
map <Leader>cf :ALEFix<CR>
map <Leader>ci :call ALEIgnore()<CR>

" Enable fixing on command for javascript.
let g:ale_fixers = {
	\'javascript': ['eslint'],
\}

" Type definitions {{{

"   text : string 
"	   The text that should be put into a comment.
"	 style : string
"	   The comment style to use.
"	   See the comment mode section under :help tcomment#Comment() for a list of options.
"	   Default is 'G' (guess).
" commentdef : string
"   Shorthand for the dict form, with the given value being used for 'text'

" formatdef : dict
"   above : commentdef
"     The comment to render above the line that has the errors.
"   inline : commentdef
"     The comment to render at the end of the line that has the errors.
"   below : commentdef
"     The comment to render below the line that has the errors.
" formatdef : commentdef
"   Shorthand for the dict form, with the given value being used for 'inline'.

" linterdef : dict
"   any string : formatdef
"     The key is the (human-readable) name of the format, the value is the formatdef to use for this format.
" linterdef : formatdef

" formatdef_func : func
"   (errors) -> result
"   errors : list[string]
"     A list of all error identifiers.
"   result : formatdef
"     The formatdef that will cause the given errors to be suppressed.

" s:ignore_rules : dict
"   The rules that dictate how ignore comments for different linters look.
"   any string : formatdef_func
"     The key is the name of a linter, the value is the formatdef_func to use for this linter.

" s:ignore_fallback : formatdef_func
"   The rules that dictate how ignore comments for linters that do not appear in s:ignore_rules look.
"   (errors, linter) -> result
"   linter : string
"     The name of the linter for which the defaults will be used.

" }}}

" Normalize functions {{{
let s:comment_def_defaults = { 'style': 'G' }
function s:NormalizeCommentDef(def)
	if type(a:def) == v:t_dict
		return a:def
	endif

	let def = copy(s:comment_def_defaults)
	let def.text = a:def
	return def
endfunction
function s:IsCommentDef(def)
	if type(a:def) == v:t_dict
		return has_key(a:def, 'text')
	endif
	return type(a:def) == v:t_string
endfunction

function! s:NormalizeFormatDef(def)
	if type(a:def) == v:t_dict && !s:IsCommentDef(a:def)
		return a:def
	endif
	return { 'inline': a:def }
endfunction
function! s:IsFormatDef(def)
	if type(a:def) == v:t_dict
		return has_key(a:def, 'above') || has_key(a:def, 'inline') || has_key(a:def, 'below')
	endif
	return s:IsCommentDef(a:def)
endfunction

function! s:NormalizeLinterDef(def)
	if type(a:def) == v:t_dict && !s:IsFormatDef(a:def)
		return a:def
	endif
	return { 'Default': a:def }
endfunction
" }}}

" Preview functions {{{
function! s:PreviewCommentDef(def)
	let def = s:NormalizeCommentDef(a:def)
	let commentstring = tcomment#commentdef#Get('.', '.', def.style).commentstring
	return substitute(printf(commentstring, ' ' . def.text . ' '), '  ', ' ', '')
endfunction

function! s:PreviewFormatDef(def)
	let def = s:NormalizeFormatDef(a:def)
	let lines = []

	if has_key(def, 'above')
		let lines += [s:PreviewCommentDef(def.above)]
	endif

	let midline = substitute(getline('.'), '^\s*', '', '')
	if has_key(def, 'inline')
		let midline = midline . ' ' . s:PreviewCommentDef(def.inline)
	endif
	let lines += [midline]

	if has_key(def, 'below')
		let lines += [s:PreviewCommentDef(def.below)]
	endif

	return join(lines, "\n")
endfunction
" }}}

" ALEIgnore {{{
function! ALEIgnore()
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

	if has_key(s:ignore_rules, s:linter)
		let linterdef = s:ignore_rules[s:linter](errors)
	else
		let linterdef = s:ignore_fallback(l:linter, errors)
	endif
	let linterdef = s:NormalizeLinterDef(linterdef)

	let s:formats = {}
	let options = []
	for [name, formatdef] in items(linterdef)
		let formatdef = s:NormalizeFormatDef(formatdef)
		let formatdef = map(formatdef, {name, commentdef -> s:NormalizeCommentDef(commentdef)})
		let s:formats[name] = formatdef
		let options += [base64#encode(s:PreviewFormatDef(formatdef)) . ' ' . name]
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
	let commentdef = s:NormalizeCommentDef(a:commentdef)
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
" }}}

function s:ExtendCommentDef(def, attr, value)
	let def = s:NormalizeCommentDef(a:def)
	let def[a:attr] = a:value
	return def
endfunction
function! s:CBlock(text)
	return s:ExtendCommentDef(a:text, 'style', 'I')
endfunction
function! s:CLine(text)
	return s:ExtendCommentDef(a:text, 'style', 'L')
endfunction

let s:ignore_rules = {
	\'eslint': {errors -> {
		\'Above': {
			\'above': s:CLine('eslint-disable-next-line ' . join(errors, ', ')),
		\},
		\'Inline': s:CLine('eslint-disable-line ' . join(errors, ', ')),
		\'Block': {
			\'above': s:CBlock('eslint-disable ' . join(errors, ', ')),
			\'below': s:CBlock('eslint-enable ' . join(errors, ', ')),
		\},
	\}},
	\'shellcheck': {errors -> {
		\'above': 'shellcheck disable=' . join(errors, ', '),
	\}},
\}
let s:ignore_fallback = {linter, errors -> {
	\'Above': {
		\'above': linter . ': disable=' . join(a:errors, ', '),
	\},
	\'Inline': linter . ': disable=' . join(a:errors, ', '),
\}}

