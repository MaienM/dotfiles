" Part of my modulized vimrc file.
" Last change: Thu, 03 Mar 2011 20:29:30 +0100

" Open one of the rc files for editing.
command! -bang -nargs=+ -complete=custom,EditRCComplete EditRC
  \ :let cmd = ':'.['e', 'tabe'][strlen("<bang>")].' ~/.vim/rc/' <Bar>
  \ let args = split("<args>", '\W\+')  <Bar>
  \ if len(args) == 1 <Bar>
  \   exe cmd.args[0].'.vim' <Bar>
  \ elseif len(args) == 2 <Bar>
  \   exe cmd.args[0].'/'.args[1].'.vim' <Bar>
  \ endif 
function! EditRCComplete(ArgLead, CmdLine, CursorPos)
  let l = split(a:CmdLine, '\W\+')
  if (len(l) == 1 || (len(l) == 2 && strlen(a:ArgLead) > 0))
    return system("ls ~/.vim/rc/*.vim | grep -oP '[^/]+(?=.vim$)'")
  elseif (len(l) == 2 || (len(l) == 3 && strlen(a:ArgLead) > 0))
    return system("ls ~/.vim/rc/".l[1]."/*.vim | grep -oP '[^/]+(?=.vim$)'")
  else
    return "\n"
  endif
endfunction

" Sort stuff by date.
command! -range=% SortDate
  \ :<line1>,<line2>sort /\s/ <Bar>
  \ <line1>,<line2>sort n /../ r <Bar>
  \ <line1>,<line2>sort n !../! <Bar>
  \ <line1>,<line2>sort n !../../! 

" Convenient command to see the difference between the current buffer and the
" file it was loaded from, thus the changes you made.
" Only define it when not defined already.
if !exists(":DiffOrig")
  command DiffOrig vert new | set bt=nofile | r # | 0d_ | diffthis 
      \ | wincmd p | diffthis | wincmd h
endif
