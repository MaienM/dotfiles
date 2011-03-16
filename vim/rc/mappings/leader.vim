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

" <Leader>r: Reload the vimrc file.
map <silent> <Leader>r :source $MYVIMRC <CR>

" <Leader>h: Open the help page for the tag under the cursor, if any.
"map <silent> <Leader>h 

" <Leader>c: Comment the selected lines.
vnoremap <Leader>c :call Comment() <CR>
function! Comment() range
  " Process the 'comments' setting to find out which characters we have to use
  " for comments.
  let l:copts = {'s': '', 'm': '', 'e': '', ':': ''}
  for l in split(&comments, ',')
    let [a; b] = split(l, ':', 1)
    if strlen(a) > 0 && a != 'n'
      let a = a[0]
    else
      let a = ':'
    endif
    let l:copts[a] = join(b, ':')
  endfor

  echo l:copts
    
  " Determine which seperatator we can use in the substitution command. The
  " default '/' would break C-style comments ('/*' .. '*/').
  let sep = ''
  let m = l:copts[':'] . l:copts['m'] . l:copts['e'] . l:copts['s']
  for s in ['/', '!', '#', '$', '%', '&']
    if stridx(m, s) == -1
      let sep = s
      break
    endif
  endfor

  " Do the actual substitution.
  let l:lineregex = ':silent %d,%ds%s\v^(\s*)%s\1%s %s'
  if a:firstline == a:lastline || l:copts['s'] == '' || l:copts['m'] == '' || l:copts['e'] == ''
    exec printf(l:lineregex,
              \ a:firstline, a:lastline, sep, sep, l:copts[':'], sep)
  else
    exec printf(l:lineregex,
              \ a:firstline, a:lastline, sep, sep, l:copts['m'], sep)
    exec printf(':silent %ds%s\v^(\s*)(.*)$%s\1\2\r\1%s%s', 
              \ a:lastline, sep, sep, l:copts['e'], sep)
    exec printf(':silent %ds%s\v^(\s*)(.*)$%s\1%s\r\1\2%s',
              \ a:firstline, sep, sep, l:copts['s'], sep)
  endif
  noh
endfunction
