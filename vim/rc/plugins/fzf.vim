let $FZF_DEFAULT_OPTS='--layout=reverse'
let g:fzf_layout = {
	\'window': {
		\'width': 0.85,
		\'height': 0.85,
		\'border': 'sharp',
	\},
\}
if $TMUX_SUPPORT_POPUP == 1
	let g:fzf_layout['tmux'] = '-p 85%,85%'
endif

let g:fzf_preview_window = ['right,50%,<100(down,50%,hidden)', '?']

function! s:Rg(args, bang)
	call fzf#vim#grep(
		\'rg --column --line-number --no-heading --color=always --smart-case ' . a:args,
		\1,
		\fzf#vim#with_preview({ 'options': ['--prompt', 'rg ' . a:args . ' >> '] }, g:fzf_preview_window[0], g:fzf_preview_window[1]),
		\a:bang,
	\)
endfunction

" From https://stackoverflow.com/a/6271254.
function! s:get_visual_selection()
	" Why is this not a built-in Vim script function?!
	let [line_start, column_start] = getpos("'<")[1:2]
	let [line_end, column_end] = getpos("'>")[1:2]
	let lines = getline(line_start, line_end)
	if len(lines) == 0
		return ''
	endif
	let lines[-1] = lines[-1][: column_end - (&selection == 'inclusive' ? 1 : 2)]
	let lines[0] = lines[0][column_start - 1:]
	return join(lines, "\n")
endfunction

command! -bang -nargs=* RgRaw call <SID>Rg(<q-args>, <bang>0)
command! -bang -nargs=* Rg call <SID>Rg('-- ' . shellescape(<q-args>), <bang>0)

nnoremap <Leader>f :<C-u>GFiles<CR>
nnoremap <Leader>F :<C-u>Files<CR>
nnoremap <Leader>vf :<C-u>GFiles?<CR>
nnoremap <Leader>b :<C-u>Buffers<CR>
nnoremap <Leader>/ :<C-u>Rg 
nnoremap <Leader>* :<C-u>Rg <C-r>=("\\b" . expand("<cword>") . "\\b")<CR><CR>
vnoremap <Leader>* :<C-u>Rg <C-r>=<SID>get_visual_selection()<CR><CR>
nnoremap <Leader>? :<C-u>Lines<CR>
nnoremap <Leader>h :<C-u>call fzf#vim#helptags(0)<CR>
nnoremap <Leader>H :<C-u>call pathogen#helptags()<CR>
