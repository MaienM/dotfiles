" Part of my modulized vimrc file.
" Last change: Sun, 02 Oct 2011 23:15:11 +0200

" Mapping for tabular.
nmap <Leader>a :Tabularize /

" Auto-(re)align bar characters.
inoremap <silent> <Bar> <Bar><Esc>:call <SID>balign()<CR>a
function! s:balign()
  let p = '^\s*|\s.*\s|\s*$'
  if exists(':Tabularize') && getline('.') =~# '^\s*|' && (getline(line('.')-1) =~# p || getline(line('.')+1) =~# p)
    let column = strlen(substitute(getline('.')[0:col('.')],'[^|]','','g'))
    let position = strlen(matchstr(getline('.')[0:col('.')],'.*|\s*\zs.*'))
    Tabularize/|/l1
    normal! 0
    call search(repeat('[^|]*|',column).'\s\{-\}'.repeat('.',position),'ce',line('.'))
  endif
endfunction

" Auto-(re)align equals characters.
inoremap <silent> = =<Esc>:call <SID>ealign()<CR>a
function! s:ealign()
  let p = '^.*=.*$'
  if exists(':Tabularize') && getline('.') =~# '^.*=' && (getline(line('.')-1) =~# p || getline(line('.')+1) =~# p)
    let column = strlen(substitute(getline('.')[0:col('.')],'[^=]','','g'))
    let position = strlen(matchstr(getline('.')[0:col('.')],'.*=\s*\zs.*'))
    Tabularize/=/l1
    normal! 0
    call search(repeat('[^=]*=',column).'\s\{-\}'.repeat('.',position),'ce',line('.'))
  endif
endfunction

