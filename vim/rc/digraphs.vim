" Part of my modulized vimrc file.
" Last change: Thu, 03 Mar 2011 17:03:49 +0100

" More digraph characters.
" Digraph characters can be entered using <C-K> when in insert mode.
if has("digraphs")
  digraph -- 8212             " em dash
  digraph `` 8220             " left double quotation mark
  digraph '' 8221             " right double quotation mark
  digraph ,, 8222             " double low-9 quotation mark
endif
