" Part of my modulized vimrc file.
" Last change: Tue, 19 Aug 2014 00:12:50 +0200

" Default matcher and sorter.
call unite#filters#matcher_default#use(['matcher_fuzzy'])
call unite#filters#sorter_default#use(['sorter_length', 'sorter_rank'])

" Ignore certain files/folders.
let s:ignore = join([
	\'\.git/',
	\'\.tox/',
	\'.*\.egg/',
	\'.*\.pyc',
\], '\|')
echom s:ignore
call unite#custom_source('file_rec,file_rec/async,file_mru,file,buffer,grep', 'ignore_pattern', s:ignore)

" File/buffer name search.
nnoremap <Leader>f :<C-u>Unite -buffer-name=unite-files -start-insert buffer file_rec/async:!<CR>

" Grep.
nnoremap <Leader>/ :<C-u>Unite -buffer-name=unite-grep grep:!<CR>

" Yanks.
let g:unite_source_history_yank_enable = 1
nnoremap <Leader>p :<C-u>Unite -buffer-name=unite-yank history/yank<CR>

" Some settings for unite buffers.
autocmd FileType unite call s:unite_settings()
function! s:unite_settings()
	" No supertab.
	let b:SuperTabDisabled=1

	" Moving up and down.
	imap <buffer> <C-j>   <Plug>(unite_select_next_line)
	imap <buffer> <C-k>   <Plug>(unite_select_previous_line)

	" Some mappings to open splits/tabs.
	imap <silent><buffer><expr> <C-x> unite#do_action('split')
	imap <silent><buffer><expr> <C-v> unite#do_action('vsplit')
	imap <silent><buffer><expr> <C-t> unite#do_action('tabopen')

	" So I can spam C-C to get out, now.
	nmap <buffer> <C-C> <Plug>(unite_exit)
endfunction
