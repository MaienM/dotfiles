" Part of my modulized vimrc file.
" Last change: Fri, 08 Jun 2012 14:45:26 +0200

" Enable by default.
let g:indent_guides_enable_on_vim_startup=1

" Colors. Change the damn colors. My poor, poor eyes.
let g:indent_guides_auto_colors=0
if !exists('g:indent_guides_mode') || g:indent_guides_mode==0 
  hi IndentGuidesOdd  ctermbg=236
  hi IndentGuidesEven  ctermbg=235
  let g:indent_guides_guide_size=0
else
  hi IndentGuidesOdd  ctermbg=237
  hi IndentGuidesEven  ctermbg=236
  let g:indent_guides_guide_size=1
endif
