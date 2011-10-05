" Part of my modulized vimrc file.
" Last change: Tue, 04 Oct 2011 23:47:55 +0200

" Open one of the rc files for editing.
command! -bang -nargs=+ -complete=custom,s:EditRCComplete EditRC
  \ :let cmd  = ':'.['e', 'tabe'][strlen("<bang>")].' ' <Bar>
  \ let args  = split("<args>", '\W\+') <Bar>
  \ let path  = join(args, '/') <Bar>
  \ let path2 = system('find ~/.vim/ -regex ".*/'.path.'.*"') <Bar>
  \ if strlen(path2) > 0 <Bar>
  \   let path = path2 <Bar>
  \ else <Bar>
  \   let path = '~/.vim/rc/'.path.'.vim' <Bar>
  \ endif <Bar>
  \ let _     = system('mkdir -p ~/.vim/rc/'.join(args[:-2], '/')) <Bar>
  \ exe cmd.path

function! s:EditRCComplete(ArgLead, CmdLine, CursorPos)
  let l = split(a:CmdLine, '\W\+')
  let l = l[1:]
  if strlen(a:ArgLead) > 0
    unlet l[len(l)-1]
  endif
  return system('ls ~/.vim/rc/'.join(l, '/').' 2> /dev/null | grep -oE "[^/]+" | grep -oP "^[^.]+(?=.vim$)|^[^.]+$" | uniq')
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
