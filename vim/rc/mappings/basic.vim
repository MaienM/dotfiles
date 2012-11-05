" Part of my modulized vimrc file.
" Last change: Sun, 02 Oct 2011 10:36:47 +0200

" Remap ; to :. Saves a keystroke on an often used key.
nnoremap ; :
" This breaks a lot of stuff. nnoremap : <nop>

" Use Alt-j and Alt-k to move up/down visual lines.
Map <A-j> gj
Map <A-k> gk

" Make Y behave consistent with D and C (from cursor to end of line).
nnoremap Y y$

" Don't lose the visual selection after changing indentation.
vnoremap > >gv
vnoremap < <gv

" Remap Q to execute the macro recorded in q. Q is normally used to enter ex
" mode, which I never use anyway.
nnoremap Q @q

" Search for the selected text when using * or # in visual mode.
" See http://got-ravings.blogspot.nl/2008/07/vim-pr0n-visual-search-mappings.html
function! s:VSetSearch()
  let temp = @@
  norm! gvy
  let @/ = '\V' . substitute(escape(@@, '\'), '\n', '\\n', 'g')
  let @@ = temp
endfunction

vnoremap * :<C-u>call <SID>VSetSearch()<CR>//<CR>
vnoremap # :<C-u>call <SID>VSetSearch()<CR>??<CR>

" CTRL-U in insert mode deletes a lot.  Use CTRL-G u to first break undo,
" so that you can undo CTRL-U after inserting a line break. Same for CTRL-W.
inoremap <C-U> <C-G>u<C-U>
inoremap <C-W> <C-G>u<C-W>
