" Part of my modulized vimrc file.
" Last change: Thu, 01 Jan 1970 01:00:00 +0100

autocmd BufEnter * call s:rails_settings()
function! s:rails_settings()
  let root = ProjectRootGuess()
  if filereadable(root . '/Rakefile')

    nnoremap <buffer> <Leader>gg :A<CR>
    nnoremap <buffer> <Leader>rtt :.Rake<CR>
    nnoremap <buffer> <Leader>rtf :Rake<CR>
    nnoremap <buffer> <Leader>rr :Dispatch -<CR>
  endif
endfunction
