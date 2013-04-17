" Part of my modulized vimrc file.
" Last change: Tue, 19 Feb 2013 13:10:38 +0100

command! -b Compile :call TexCompile("%")<CR>

function! TexCompile(file)
  if getline(1) =~ "\documentclass*" |
    execute('!pdflatex -halt-on-error -file-line-error -shell-escape "'.a:file.'" | grep -E ".+:[0-9]+:.*" || true') |
  endif
endfunction
