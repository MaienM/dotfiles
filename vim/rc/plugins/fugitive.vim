" Part of my modulized vimrc file.
" Last change: Thu, 01 Jan 1970 01:00:00 +0100

" Vertical splits.
set diffopt+=vertical

" Decent preview window height.
set previewheight=15

" Mappings.
nnoremap <Leader>gg :Gstatus<CR>

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
