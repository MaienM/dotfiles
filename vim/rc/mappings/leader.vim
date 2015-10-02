" Part of my modulized vimrc file.
" Last change: Tue, 15 Apr 2014 23:55:04 +0000

" Leader key.
nnoremap <Space> <nop>
let mapleader="\<Space>"

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

" <Leader>c?: Quickfix list stuff.
nnoremap <silent> <Leader>cc :cw <bar> cc<CR>
nnoremap <silent> <Leader>c, :cp<CR>
nnoremap <silent> <Leader>c. :cn<CR>
nnoremap <silent> <Leader>cd :ccl<CR>

" <Leader>w: Write file.
nnoremap <silent> <Leader>w :w<CR>
