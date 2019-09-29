function! s:GetHighlightGroup(line, col)
	return synIDattr(synID(a:line, a:col, 1), 'name')
endfunction

function! AsciidocFoldexpr(lnum)
	" Header. Only a single level 1 header (title) is allowed, and it must be at the start, so don't fold on this, as it
	" will always contain the entire document.
	let line = getline(a:lnum)
	if line =~ '^=\{2,6}\s\+\S'
		return '>'.(matchend(line, '^=\+') - 1)
	endif

	" Fenced blocks.
	let regex_is_fence = '^[-\.*=_+/]\{4}\|[-"]\{2}\||===\|```.*$'
	if line =~ regex_is_fence
		let group_at = s:GetHighlightGroup(a:lnum, 1)
		let prev_is_same_group = s:GetHighlightGroup(a:lnum - 1, 1) == group_at
		let next_is_same_group = s:GetHighlightGroup(a:lnum + 1, 1) == group_at

		if (prev_is_same_group && next_is_same_group)
			" Two groups of the same type back to back, so determine where one begins and the other ends by looking at the
			" contents of the lines. This might fail if there are empty blocks back to back, so don't do that.
			if getline(a:lnum) == getline(a:lnum + 1)
				" Both the current line and the next line are fences, so the current line is the end of the first block. 
				return 's1'
			else
				return 'a1'
			endif
		endif

		if prev_is_same_group
			" The previous line was also part of this group, so this line is probably the end of the group.
			return 's1'
		endif
		if next_is_same_group
			" The next line is also part of this group, so this line is probably the start of the group.
			return 'a1'
		endif
	end

	return '='
endfunction

setlocal foldexpr=AsciidocFoldexpr(v:lnum)
setlocal foldmethod=expr
