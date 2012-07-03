" Part of my modulized vimrc file.
" Last change: Thu, 22 Mar 2012 14:05:26 +0100

augroup tex
au!
  " Call, if the file exists.
  function! DoIfExists(file, command, delay)
    execute '!sleep ' . a:delay . ' && bash -c "if [[ -f \"' . a:file . '\" ]]; then ' . a:command . ' &> /dev/null; fi &> /dev/null &" &> /dev/null &'
  endfunction

  " Compile files when saving them.
  au BufWritePost *.tex :call TexCompile("<afile>")
  function! TexCompile(file)
    if getline(1) =~ "\documentclass*" |
      execute('!pdflatex -halt-on-error -file-line-error -shell-escape "'.a:file.'" | grep -E ".+:[0-9]+:.*" || true') |
    endif
  endfunction

  " Define preview command.
  command! Preview call DoIfExists(expand('%:p:r').'.pdf', 'zathura --fork \"'.expand('%:p:r').'.pdf\"', 0)

  " Reload previews (in zathura) when saving files.
  au BufWritePost *.tex silent! call DoIfExists(expand('%:p:r') . '.pdf', 'xdotool search -name "'.expand("<afile>:r").'" key R', 0)

  " Keep my school files on dropbox as well.
  au BufWritePost MB*.tex silent! call DoIfExists(expand('<afile>:r') . '.pdf', 'cp "'.expand('<afile>:r').'.pdf" ~/Dropbox/School/2IL05/', 5)

augroup END

