" Part of my modulized vimrc file.
" Last change: Thu, 03 Mar 2011 16:53:26 +0100

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

" <Leader>r: Reload the vimrc file.
map <silent> <Leader>r :source $MYVIMRC <CR>

" <Leader>h: Open the help page for the tag under the cursor, if any.
"map <silent> <Leader>h 

" <Leader>c: Comment/uncomment the selected lines.
"Map <silent> <Leader>c 

