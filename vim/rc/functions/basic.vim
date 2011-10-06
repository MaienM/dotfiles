" Part of my modulized vimrc file.
" Last change: Thu, 06 Oct 2011 10:43:06 +0200

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
