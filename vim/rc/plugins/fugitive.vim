" Vertical splits.
set diffopt+=vertical

" Decent preview window height.
set previewheight=20

" Some settings for git buffers.
autocmd FileType gitcommit call s:settings()
function! s:settings()
  " No supertab.
  let b:SuperTabDisabled=1

  " No folding.
  setlocal nofoldenable

  " So I can spam C-C to get out, now.
  nmap <buffer> <C-C> :<C-U>q<CR>
endfunction

" Mappings
nnoremap <Leader>gg :Gstatus<CR>
