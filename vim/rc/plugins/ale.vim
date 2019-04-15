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

" Mapping to ignore the current error(s).
let s:ignore_funcs = {
	\'eslint': {errors -> 'eslint-disable-line ' . join(errors, ', ')},
\}
function! s:CreateIgnoreLine(plugin, errors)
	if has_key(s:ignore_funcs, a:plugin)
		return s:ignore_funcs[a:plugin](a:errors)
	else
		" This variant seems to work for a fair number of linters, so let's use it was default.
		return a:plugin . ': disable=' . join(a:errors, ', ')
	endif
endfunction
function! ALEIgnore()
	" Group the errors by the plugin that reported them.
	let l:errors = ale#list#GetCombinedList()
	let l:to_ignore = {}
	for l:error in l:errors
		if l:error.lnum == line('.')
			let l:plugin = l:error.linter_name
			if has_key(l:to_ignore, l:error.linter_name) == 0
				let l:to_ignore[l:plugin] = []
			endif
			let l:to_ignore[l:error.linter_name] += [l:error.code]
		endif
	endfor
	" Add an ignore line for each found plugin. This might not work properly if multiple plugins report errors, but
	" it tries.
	for [l:plugin, l:errors] in items(l:to_ignore)
		let l:line = s:CreateIgnoreLine(l:plugin, l:errors)
		call append('.', l:line)
		:.+1Commentary
		join
	endfor
endfunction
map <Leader>ci :call ALEIgnore()<CR>

" Enable fixing on command for javascript.
let g:ale_fixers = {
	\'javascript': ['eslint'],
\}
