if exists('g:loaded_aleignore_plugin')
	finish
endif
let g:loaded_aleignore_plugin = 1

function s:ExtendCommentDef(def, attr, value)
	let def = aleignore#types#NormalizeCommentDef(a:def)
	let def[a:attr] = a:value
	return def
endfunction
function! s:CBlock(text)
	return s:ExtendCommentDef(a:text, 'style', 'I')
endfunction
function! s:CLine(text)
	return s:ExtendCommentDef(a:text, 'style', 'L')
endfunction

let g:aleignore_rules = {
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
		\'above': 'shellcheck disable=' . join(errors, ','),
	\}},
\}

let g:Aleignore_fallback = {linter, errors -> {
	\'Above': {
		\'above': linter . ': disable=' . join(errors, ', '),
	\},
	\'Inline': linter . ': disable=' . join(errors, ', '),
\}}

let g:aleignore_commentdef_defaults = {
	\'style': 'G',
\}

command! ALEIgnore :call aleignore#ALEIgnore()<CR>

