autocmd BufEnter * call s:settings()
function! s:settings()
  let root = ProjectRootGuess()
  if filereadable(root . '/Rakefile')

    nnoremap <buffer> <Leader>ga :A<CR>
    nnoremap <buffer> <Leader>rtt :.Rake<CR>
    nnoremap <buffer> <Leader>rtf :Rake<CR>
  endif
endfunction
