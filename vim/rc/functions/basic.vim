" Part of my modulized vimrc file.
" Last change: Tue, 15 Mar 2011 18:06:51 +0100

" Open one of the rc files for editing.
command! -bang -nargs=+ -complete=custom,EditRCComplete EditRC
  \ :let cmd = ':'.['e', 'tabe'][strlen("<bang>")].' ~/.vim/rc/' <Bar>
  \ let args = split("<args>", '\W\+') <Bar>
  \ let _ = system('mkdir -p '.join(args[:-2], '/')) <Bar>
  \ exe cmd.join(args, '/').'.vim'
function! EditRCComplete(ArgLead, CmdLine, CursorPos)
  let l = split(a:CmdLine, '\W\+')
  let l = l[1:]
  if strlen(a:ArgLead) > 0
    unlet l[len(l)-1]
  endif
  return system('ls ~/.vim/rc/'.join(l, '/').' 2> /dev/null | grep -oE "[^/]+" | grep -oP "^[^.]+(?=.vim$)|^[^.]+$"')
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
