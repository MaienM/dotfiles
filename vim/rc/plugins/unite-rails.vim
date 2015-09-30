" Part of my modulized vimrc file.
" Last change: Thu, 01 Jan 1970 01:00:00 +0100

autocmd BufEnter * call s:unite_rails_settings()
function! s:unite_rails_settings()
  let root = ProjectRootGuess()
  if filereadable(root . '/Rakefile')
    nnoremap <buffer> <Leader>gm :<C-u>Unite -buffer-name=rails -start-insert rails/model<CR>
    nnoremap <buffer> <Leader>gv :<C-u>Unite -buffer-name=rails -start-insert rails/view<CR>
    nnoremap <buffer> <Leader>gc :<C-u>Unite -buffer-name=rails -start-insert rails/controller<CR>
    nnoremap <buffer> <Leader>gt :<C-u>Unite -buffer-name=rails -start-insert rails/spec<CR>
    nnoremap <buffer> <Leader>gl :<C-u>Unite -buffer-name=rails -start-insert rails/lib<CR>
  endif
endfunction
