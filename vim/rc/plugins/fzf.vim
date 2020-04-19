" If available, use NeoVim's floating windows for fzf.
if exists('*nvim_open_win')
	let $FZF_DEFAULT_OPTS='--layout=reverse'
	let g:fzf_layout = { 'window': 'call FloatingFZF()' }

	function! FloatingFZF()
		let buf = nvim_create_buf(v:false, v:true)
		call setbufvar(buf, '&signcolumn', 'no')

		let width = float2nr(&columns - (&columns / 10))
		let height = float2nr(&lines - (&lines / 10 * 3))
		let col = float2nr((&columns - width) / 2)
		let row = float2nr((&lines - height) / 2)

		let opts = {
			\'relative': 'editor',
			\'width': width,
			\'height': height,
			\'col': col,
			\'row': row
		\}

		call nvim_open_win(buf, v:true, opts)
	endfunction
endif

command! -bang -nargs=* Rg call fzf#vim#grep(
	\'rg --column --line-number --no-heading --color=always --smart-case ' . shellescape(<q-args>),
	\1,
	\fzf#vim#with_preview({ 'options': ['--prompt', 'rg ' . <q-args> . ' >> '] }, 'up:50%:hidden', '?'),
	\<bang>0,
\)

nnoremap <Leader>f :<C-u>GFiles<CR>
nnoremap <Leader>F :<C-u>Files<CR>
nnoremap <Leader>vf :<C-u>GFiles?<CR>
nnoremap <Leader>b :<C-u>Buffers<CR>
nnoremap <Leader>/ :<C-u>Rg 
nnoremap <Leader>? :<C-u>Lines<CR>
nnoremap <Leader>h :<C-u>call fzf#vim#helptags(0)<CR>
nnoremap <Leader>H :<C-u>call pathogen#helptags()<CR>

