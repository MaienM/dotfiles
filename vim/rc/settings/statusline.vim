" Part of my modulized vimrc file.
" Last change: Thu, 03 Mar 2011 17:03:23 +0100

set laststatus=2
set statusline=                         " statusline
set statusline+=%<%f                    " relative filename
set statusline+=\                       " 
set statusline+=%{TagName()}%*          " the name of the current tag, if any
set statusline+=\                       " 
set statusline+=%h                      " [Help] if this is a help buffer
set statusline+=%m                      " [+] if modified, [-] if not modifiable
set statusline+=%r                      " [RO] if readonly
set statusline+=\                       " 
set statusline+=%{IndentType()}%*       " the indent type (S or T) + length
set statusline+=%{SpecialModes()}%*     " special modes such as mouse=r or paste
set statusline+=%{Highlights()}%*       " what custom highlights are on
set statusline+=%=                      " right-align the rest
set statusline+=%l,%c                   " line,column
set statusline+=\                       " 
set statusline+=%L                      " total number of lines in buffer
set statusline+=\                       " 
set statusline+=%P                      " position in buffer as percentage

" Functions for the statusline.
function! E(arg, ...)
  if a:0 != 0
    let fmt = a:1
  else
    let fmt = '[_@_]'
  endif

  if type(a:arg) == type('') || type(a:arg) == type(0)
    return substitute(fmt, '_@_', a:arg, '')
  elseif type(a:arg) == type([])
    if len(a:arg)
      return substitute(fmt, '_@_', join(a:arg, ','), '')
    else
      return ''
    endif
  else
    return ''
  endif
endfunction

function! TagName()
  return E(Tlist_Get_Tagname_By_Line(), '{_@_}')
endfunction
function! SpecialModes()
  let retvals = []
  if &paste
    let retvals += ['CP']
  endif
  return E(retvals)
endfunction 
function! IndentType()
  let retval = ''
  if &expandtab 
    let retval .= 'S'
  else
    let retval .= 'T'
  endif
  return E(retval.&sw)
endfunction
function! Highlights()
  let retvals = []
  if exists('w:long_line_match_80')
    let retvals += ['LL']
  endif
  if exists('w:wrong_indent_match')
    let retvals += ['WI']
  endif
  return E(retvals)
endfunction

