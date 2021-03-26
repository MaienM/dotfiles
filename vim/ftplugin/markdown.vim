"  Virtual titles for wikilinks.
func! s:MatchAll(text, pattern)
	let l:results = []
	let l:count = 1
	let l:found = match(a:text, a:pattern, 0, l:count)
	while l:found != -1
		call add(l:results, matchstrpos(a:text, a:pattern, 0, l:count))
		let l:count += 1
		let found = match(a:text, a:pattern, 0, l:count)
	endwhile
	return l:results
endf

func! s:NeuronAddVirtualTitles()
	if !exists("g:_neuron_zettels_titles_list")
		return
	end
	if !exists('*nvim_buf_set_extmark')
		return
	endif

	let l:ns = nvim_create_namespace('neuron')
	call nvim_buf_clear_namespace(0, l:ns, 0, -1)
	let l:re_neuron_link = '\[\[\([0-9a-zA-Z_-]\+\)\(?cf\)\?\]\]'
	let l:lnum = 0
	for l:line in getbufline(bufname('%'), 1, "$")
		let l:titles = []
		for l:match in s:MatchAll(l:line, l:re_neuron_link)
			let l:zettel_id = matchlist(l:match[0], l:re_neuron_link)[1]
			if has_key(g:_neuron_zettels_titles_list, l:zettel_id)
				call add(l:titles, g:_neuron_zettels_titles_list[l:zettel_id])
				" call nvim_buf_set_extmark(0, l:ns, l:lnum, l:match[2], { 'virt_text': [[l:title, g:style_virtual_title]] })
			endif
		endfor

		if !empty(l:titles)
			let l:chunks = []
			for l:title in l:titles
				call add(l:chunks, [' '])
				call add(l:chunks, ['[[' . l:title . ']]', 'TabLineFill'])
			endfor
			call remove(l:chunks, 0)
			call nvim_buf_set_virtual_text(0, l:ns, l:lnum, l:chunks, {})
		endif

		let l:lnum += 1
	endfor
endf

if exists('g:neuron_dir') && xolox#misc#path#starts_with(expand('%:p'), g:neuron_dir)
	nmap <buffer> <Leader>NN <Plug>EditZettelBacklink
	nmap <buffer> <Leader>Nt <Plug>TagsAddSelect
	nmap <buffer> <Leader>NT <Plug>TagsAddNew

	imap <buffer> [[ <C-O><Plug>InsertZettelSelect

	augroup neuronFTPlugin
		au!
		au BufEnter <buffer> call <SID>NeuronAddVirtualTitles()
		au InsertLeave <buffer> call <SID>NeuronAddVirtualTitles()
	augroup END
	call s:NeuronAddVirtualTitles()
endif
