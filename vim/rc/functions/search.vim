" Part of my modulized vimrc file.
" Last change: Thu, 01 Jan 1970 01:00:00 +0100

" Save and restore search strings
function! SearchSaveAndRestore(...)
  if a:0 && a:1 ==# "get"
    return s:search_str
  endif

  if ( @/ == "" )
    let @/ = s:search_str
  else
    let s:search_str = @/
  endif
  return @/
endfunction

" Returns a list of open buffers
function! BuffersList()
  let all = range(0, bufnr('$'))
  let res = []
  for b in all
    if buflisted(b)
      call add(res, bufname(b))
    endif
  endfor
  return res
endfunction

" Find all the lines that contain the search term and display them in the location list
" Arguments:
"   scope (str) "local":   Find only with the current buffer and display
"						   results in a location list
"               "global":  Find across all windows and display results in a quickfix list
"   mode  (str) "normal":  The default mode. Use the default value if provided one
"               "visual":  Use the value stored in @* to search
"               "prev":    Use the previously searched term
"   default (a:1, str):    Default value to be specified at the "Find: "
"						   prompt. Meaningful only in "normal" mode
function! FindAndList(scope, mode, ...)
  let prompt = (a:0 > 0 ? a:1 : "")
  if a:mode ==? "visual"
    let prompt = escape(@*, '$*[]/')
  elseif a:mode ==? "prev"
    if neobundle#is_sourced('unite.vim')
      if (a:scope ==? "local")
        execute 'Unite -toggle -buffer-name=Search grep:% -resume'
      elseif (a:scope ==? "global")
        execute 'Unite -toggle -buffer-name=Search grep:$buffers -resume'
      endif
      return
    endif
    let prompt = SearchSaveAndRestore('get')
  endif
  let term = input(substitute(a:scope, ".*", "\\L\\u\\0", "") . ": /", prompt)

  let v:errmsg = ""
  " Return if search term is empty
  if term == ""
    "let term = expand('<cword>')
    return
  endif
  if (v:errmsg != "") | return | endif

  " Use Unite if available
  if neobundle#is_sourced('unite.vim')
    if (a:scope ==? "local")
      execute 'Unite -toggle -buffer-name=Search grep:%::' . term
    elseif (a:scope ==? "global")
      execute 'Unite -toggle -buffer-name=Search grep:$buffers::' . term
    endif
  else
    if (a:scope ==? "local")
      execute "lvimgrep! /" . term . "/ " . fnameescape(expand('%:p'))
      lopen 15
    elseif (a:scope ==? "global")
      execute "vimgrep! /" . term . "/ " . join(BuffersList())
      copen 15
    endif
  endif
endfunction
