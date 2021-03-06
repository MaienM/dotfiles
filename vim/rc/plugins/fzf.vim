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

