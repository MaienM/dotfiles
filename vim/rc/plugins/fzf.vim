command! -bang -nargs=* Rg call fzf#vim#grep(
	\'rg --column --line-number --no-heading --color=always --smart-case ' . shellescape(<q-args>),
	\1,
	\<bang>0 ? fzf#vim#with_preview('up:60%') : fzf#vim#with_preview('right:50%:hidden', '?'),
	\<bang>0,
\)

nnoremap <Leader>f :<C-u>GFiles<CR>
nnoremap <Leader>F :<C-u>Files<CR>
nnoremap <Leader>gf :<C-u>GFiles?<CR>
nnoremap <Leader>b :<C-u>Buffers<CR>
nnoremap <Leader>/ :<C-u>exe 'Rg ' . input('Pattern: ')<CR>
nnoremap <Leader>? :<C-u>Lines<CR>
nnoremap <Leader>h :<C-u>call fzf#vim#helptags(0)<CR>
nnoremap <Leader>H :<C-u>call pathogen#helptags()<CR>
