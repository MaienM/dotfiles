" Part of my modulized vimrc file.
" Last change: Mon, 14 Mar 2011 15:20:07 +0100

" <Leader>`: Switch between 'Proper Capitalisation', 'ALL CAPS', and
" 'all lowercase'.
vnoremap <Leader>` ygv"=TwiddleCase(@")<CR>Pgv
function! TwiddleCase(str)
  if a:str ==# toupper(a:str)
    let result = tolower(a:str)
  elseif a:str ==# tolower(a:str)
    let result = substitute(a:str,'\(\<\w\+\>\)', '\u\1', 'g')
  else
    let result = toupper(a:str)
  endif
  return result
endfunction

" <Leader>rl: Reload the vimrc file.
" <Leader>re: Edit an vimrc file (command-t on the .vim directory).
nnoremap <silent> <Leader>rl :source $MYVIMRC<CR>
nnoremap <silent> <Leader>re :CommandT ~/.vim<CR>

" <Leader>f: Command-t (Find file).
nnoremap <silent> <Leader>f :CommandT<CR>

" <Leader>ml: Insert indentation modeline, based on current settings.
nnoremap <silent> <Leader>ml :call AppendModeline()<CR>
function! AppendModeline()
  let l:modeline = "vim"

  if &expandtab
    let l:modeline .= ":et"
    let l:modeline .= ":sw=" . &shiftwidth
  else
    let l:modeline .= ":net"
    let l:modeline .= ":ts=" . &tabstop
    if &softtabstop > 0
      let l:modeline .= ":sts=" . &softtabstop
    endif
  endif

  if &textwidth > 0
    let l:modeline .= ":tw=" . &textwidth
  endif 

  let l:modeline = substitute(&commentstring, "%s", l:modeline, "")
  call append(line("$"), l:modeline)
endfunction

