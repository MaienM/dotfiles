" Part of my modulized vimrc file.
" Last change: Tue, 13 Nov 2012 09:28:33 +0100

command! -b Compile :silent! call TexCompile("<afile>")<CR>

function! TexCompile(file)
  if getline(1) =~ "\documentclass*" |
    execute('!pdflatex -halt-on-error -file-line-error -shell-escape "'.a:file.'" | grep -E ".+:[0-9]+:.*" || true') |
  endif
endfunction
