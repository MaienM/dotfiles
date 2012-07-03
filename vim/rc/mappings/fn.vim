" Part of my modulized vimrc file.
" Last change: Sat, 24 Mar 2012 17:14:10 +0100

" F1-F4: Mappings to assist lazy me in being lazy.
" F1: Disabled. If I want help, I'll use :help, tyvm.
Map <silent> <F1> <nop>

" F3: Swap between absolute and relative numbers.
Map <silent> <F3> :if &number <Bar> set relativenumber <Bar> else <Bar> set number <Bar> endif <CR>

" F4: Clear the highlighting of the current search.
Map <silent> <F4> :noh <CR>

" F5-F8: Stuff that edits/alters/works on the current file in any way.
" F5: Toggle paste mode.
Map <silent> <F5>
  \ :let &paste = !&paste <Bar>
  \ if exists('oldshowbreak') <Bar>
  \   let &showbreak = oldshowbreak <Bar>
  \   unlet oldshowbreak <Bar>
  \ else <Bar>
  \   let oldshowbreak = &showbreak <Bar>
  \   set showbreak= <Bar>
  \ endif <CR>
set pastetoggle=<F5>

" F6: Rotate indent width 2 -> 3 -> 4 -> 6 -> 8.
" Shift_F6: Toggle expandting tabs into spaces.
" Ctrl_F6: Specify whether to use tabs or spaces, and the width of a tab.
Map <silent> <F6> :Indent (&sw+1)+(&sw>3)-((&sw==8)*8) &expandtab <CR>
Map <silent> <S-F6> :Indent &sw !&expandtab <CR>
Map <silent> <C-F6> :Indent float2nr(pow(confirm("","&2\n&3\n&4\n&6\n&8")+1,1.1607)) !(confirm("","&\ Space\n&\tTab")-1) <CR>
command! -nargs=+ Indent 
  \ :let r = [<f-args>] <Bar>
  \ let &sw = eval(r[0]) <Bar>
  \ let &expandtab = eval(r[1]) <Bar>
  \ let origts = exists('origts') ? origts : &ts <Bar>
  \ if &expandtab <Bar>
  \   let &sts = &sw <Bar>
  \   let &ts = origts <Bar>
  \ else <Bar>
  \   let &ts = &sw <Bar>
  \ endif <Bar>
  \ call WrongIndentHighlight(1)

" F7: Reload the file.
" Ctrl_F7: Force-reload the file.
Map <silent> <F7> :e <CR>
Map <silent> <C-F7> :e! <CR>

" F8: Save the file.
" Ctrl_F8: Force-save the file.
" Shift_F8: Save and exit.
" Ctrl_Shift_F8: Force-save and exit.
Map <silent> <F8> :w <CR>
Map <silent> <C-F8> :w! <CR>
Map <silent> <S-F8> :wq <CR>
Map <silent> <C-S-F8> :wq! <CR>

" F9-F12: Stuff that displays points of attention in the current file.
" F9: Toggle highlighting of too long lines.
Map <silent> <F9>
  \ :highlight LongLine80 ctermbg=darkred <Bar>
  \ highlight LongLine120 ctermbg=darkgreen <Bar>
  \ if exists('w:long_line_match_80') <Bar>
  \    silent! call matchdelete(w:long_line_match_80) <Bar>
  \    silent! call matchdelete(w:long_line_match_120) <Bar>
  \    unlet w:long_line_match_80 w:long_line_match_120 <Bar>
  \ else <Bar>
  \    let w:long_line_match_80  = matchadd('LongLine80',  '\%>80v.\+\%<122v', -1) <Bar>
  \    let w:long_line_match_120 = matchadd('LongLine120', '\%>120v.\+', -1) <Bar>
  \ endif <CR>

" F10: Toggle highlighting of wrong indentation, wrong being anything
" different from the current indentation.
Map <silent> <F10> :call WrongIndentHighlight(0) <CR>
function! WrongIndentHighlight(refresh)
  highlight WrongIndent ctermbg=darkblue
  let e = exists('w:wrong_indent_match')
  if e
    silent! call matchdelete(w:wrong_indent_match)
    unlet w:wrong_indent_match
  endif
  if (e+a:refresh) == 1 
    return
  endif
  if &expandtab
    let w:wrong_indent_match = matchadd('WrongIndent', printf('\(\t\)\|\(\(\(^\([ ]\{%d}\)*\)\@<=\([ ]\{1,%d}\)\)\([^ ]\)\@=\)', &sw, &sw-1), -1)
  else
    let w:wrong_indent_match = matchadd('WrongIndent', '\(^ \+[^*]\)\|\(\(\S\)\@<=\t\+\)', -1)
  endif
endfunction

" F11: Toggle gundo.
Map <silent> <F11> :GundoToggle <CR>

" F12: Toggle the taglist.
" Ctrl_F12: Close the taglist.
Map <silent> <F12> :TlistToggle <CR>

