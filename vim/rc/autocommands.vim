if has("autocmd") 
  " Define the autocmd group, so we can delete all of these when reloading the
  " file.
  augroup vimrc

  " Delete all autocommands previously defined in this group.
  au!

  " Load autocommand rc files.
  runtime! rc/autocommands/**/*.vim
  
  " Close the autocmd group.
  augroup END
endif

