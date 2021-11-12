let g:polyglot_disabled=[]

"=== LaTeX ===

" Don't mess with indents.
let g:LatexBox_custom_indent=0

"=== JavaScript ===

" Enable syntax highlighting for jsdoc.
let g:javascript_plugin_jsdoc = 1

" Have syntax bases highlighting for javascript.
au FileType javascript setlocal foldmethod=syntax

"=== JSX ===

" Use the same highlighting for XML (and JSX) end tags as for the start tags.
hi link xmlEndTag xmlTag

"=== Python ===

" The indent plugin assumes PEP8, which is not true for my personal scripts since I prefer tabs over spaces.
call add(g:polyglot_disabled, 'python-indent')
