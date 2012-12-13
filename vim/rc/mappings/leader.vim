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

" <Leader>c: Comment the selected lines.
vnoremap <Leader>" :call Comment()<CR>
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

" Example of the following actions for an android app:
" Compile: Compile the code to an APK.
" Preview: Install/run the latest apk on an emulator.
" Deploy: Install/run the latest apk on a phone.
" Refresh: Not implemented.
" Save: Do nothing.

" Example for an latex file:
" Compile: Compiles the file into a PDF.
" Preview: Open's the PDF.
" Deploy: Same as preview.
" Refresh: Refreshes the currently running preview.
" Save: Compile + Refresh.

" Depending on how heavy this all is, it can be set to auto compile/refresh
" automatically when saving (for latex files this might be appropriate, to
" have a "live" preview), or to only do this when told to do so manually.

" <Leader>bc: Compile the current file.
map <Leader>bc :Compile<CR>

" <Leader>bp: Preview the current file.
map <Leader>bp :Preview<CR>

" <Leader>bd: Deploy the current file.
map <Leader>bd :Deploy<CR>

" <Leader>br: Refresh the current file. 
map <Leader>br :Refresh<CR>
