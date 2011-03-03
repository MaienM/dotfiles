" Part of my modulized vimrc file.
" Last change: Thu, 03 Mar 2011 20:28:45 +0100

if has("autocmd") 
  " Define the autocmd group, so we can delete all of these when reloading the
  " file.
  augroup vimrc

  " Delete all autocommands previously defined in this group.
  au!

  " Automatically jump to the position we were at when last editing a file
  " when opening it.
  au BufRead * '"

  " Autmatically update the "Last edited" comments at the top of some my files 
  " (such as this one) when saving a file. Only operates on the top 10 lines,
  " and only processes the first mathing line it comes across.
  if exists("*strftime")
    au BufWrite * mark ' |
                \ let n=0 |
                \ silent! 1,10g/\vLast (change|edit).*/
                \ if n==0 |
                \   s//\='Last change: '.strftime('%a, %d %b %Y %T %z')/ |
                \   let n=1 |
                \   noh |
                \ endif
    au BufWrite * unlet n |
                \ ''
  endif

  " Automatically make files that start with the shebang (#!...) executable.
  au BufWritePost * 
  \ if getline(1) =~ "^#!" |
  \   if getline(1) =~ "/bin" |
  \     execute('silent !chmod +x <afile>') |
  \   endif |
  \ endif

  " Warn me when saving an userscript with an improper version.
  au BufWrite *.js silent! 
  \ if search('@version', 'n') != 0 |
  \   if search('@version\s\+\([0-9.]\+\)\_.*changelog.*\n.*version \1$', 'n') == 0 |
  \     echoerr "The version of the script seems to be incorrect." |
  \     exe 'normal \<Esc' |
  \   endif |
  \ endif

  " Automatically reload vimrc files when saving one vimrc file.
  au BufWritePost *.vim normal \r

  " Close the autocmd group.
  augroup END
endif

