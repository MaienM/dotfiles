" Part of my modulized vimrc file.
" Last change: Sun, 06 Mar 2011 09:49:14 +0100

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
vnoremap <Leader>c :Comment <CR>
command! -range Comment
  \ :let copts = {} <Bar>
  \ let list = split(&comments, ',') <Bar>
  \ for l in list <Bar>
  \   let [a, b] = split(l, ':', 1) <Bar>
  \   if strlen(a) > 0 <Bar>
  \     let a = a[0] <Bar>
  \   else <Bar>
  \     let a = ':' <Bar>
  \   endif <Bar>
  \   let copts[a] = b <Bar>
  \ endfor <Bar>
  \ unlet list <Bar>
  \ if <line1>==<line2> <Bar>
  \   exec ':<line1>s/\v^(\s*)/\1'.copts[':'].' /' <Bar>
  \ else <Bar>
  \   exec ':<line1>,<line2>s/\v^(\s*)/\1'.copts['m'].'/' <Bar>
  \   exec ':<line2>s/\v^(\s*)(.*)$/\1\2\r\1'.copts['e'].'/' <Bar>
  \   exec ':<line1>s/\v^(\s*)(.*)$/\1'.copts['s'].'\r\1\2/' <Bar>
  \ endif <Bar>
  \ noh
