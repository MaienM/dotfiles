" Use space as leader.
nnoremap <Space> <nop>
let mapleader='\<Space>'

" Make Y behave consistent with D and C (from cursor to end of line).
nnoremap Y y$

" Don't lose the visual selection after changing indentation.
vnoremap > >gv
vnoremap < <gv

" Remap Q to execute the macro recorded in q. Q is normally used to enter ex mode, which I never use anyway.
nnoremap Q @q

" Search for the selected text when using * or # in visual mode.
" See http://got-ravings.blogspot.nl/2008/07/vim-pr0n-visual-search-mappings.html.
function! s:VSetSearch()
	let temp = @@
	norm! gvy
	let @/ = '\V' . substitute(escape(@@, '\'), '\n', '\\n', 'g')
	let @@ = temp
endfunction
vnoremap * :<C-u>call <SID>VSetSearch()<CR>//<CR>
vnoremap # :<C-u>call <SID>VSetSearch()<CR>??<CR>

" CTRL-U in insert mode deletes a lot.  Use CTRL-G u to first break undo, so that you can undo CTRL-U after inserting a
" line break. Same for CTRL-W.
inoremap <C-U> <C-G>u<C-U>
inoremap <C-W> <C-G>u<C-W>

" Map jj to esc in insert mode. Esc is too far away.
inoremap jj <C-C>
imap <Esc> <nop>

" H -> start of line, L -> end of line.
nnoremap H ^
nnoremap L $

" F5 to exit paste mode.
set pastetoggle=<F5>

" Mapping to use a temp file as 'clipboard', in case other clipboards don't want to cooperate.
vmap <Leader><Leader>y :w! /tmp/vitmp<CR>                                                                   
nmap <Leader><Leader>p :r! cat /tmp/vitmp<CR>
