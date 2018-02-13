" Check on insert mode leave instead of during typing
let g:ale_lint_on_text_changed = 'normal'
let g:ale_lint_on_insert_leave = 1

map <Leader>ss :ALEToggle<CR>

" Mapping to ignore the current eslint error(s)
function! ALEIgnore()
	let errors = ale#list#GetCombinedList()
	let toIgnore = []
	for error in errors
		if error.lnum == line('.') && error.linter_name == 'eslint'
			let toIgnore += [error.code]
		endif
	endfor
	execute 'normal A // eslint-disable-line ' . join(toIgnore, ', ')
endfunction
map <Leader>si :call ALEIgnore()<CR>
