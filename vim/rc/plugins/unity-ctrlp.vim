" Part of my modulized vimrc file.
" Last change: Sun, 22 Jun 2014 17:00:35 +0200

" Unity CTRL-P behavior.
call unite#custom_source('file_rec,file_rec/async,file_mru,file,buffer,grep',
	\'ignore_pattern', join([
		\'\.git/',
		\'*\.egg/*',
    \], '\|')
\)

"call unite#filters#matcher_default#use(['matcher_fuzzy'])
"call unite#filters#sorter_default#use(['sorter_rank'])

"nnoremap <C-P> :<C-u>Unite -buffer-name=files -start-insert buffer file_rec/async:!<cr>
nnoremap <Leader>f :<C-u>Unite -buffer-name=files -start-insert buffer file_rec/async:!<cr>

autocmd FileType unite call s:unite_settings()

function! s:unite_settings()
  let b:SuperTabDisabled=1
  imap <buffer> <C-j>   <Plug>(unite_select_next_line)
  imap <buffer> <C-k>   <Plug>(unite_select_previous_line)
  imap <silent><buffer><expr> <C-x> unite#do_action('split')
  imap <silent><buffer><expr> <C-v> unite#do_action('vsplit')
  imap <silent><buffer><expr> <C-t> unite#do_action('tabopen')

  nmap <buffer> <Esc> <Plug>(unite_exit)
endfunction
