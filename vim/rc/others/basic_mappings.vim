" Part of my modulized vimrc file.
" Last change: Sun, 02 Oct 2011 10:36:47 +0200

" command Map to map and imap at the same time.
command! -nargs=+ -complete=mapping Map 
  \ :let [start; end] = split('<expr> '.<q-args>, printf('\(\s\+\)\(<%s>\)\@!', join(['buffer', 'silent', 'special', 'script', 'expr', 'unique'], '>\|<'))) <Bar>
  \ let start = strpart(start, 7) <Bar>
  \ execute(printf(':map %s', <q-args>)) <Bar>
  \ execute(printf(':imap %s %s <LT>C-O>%s', start, end[0], end[0]))

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

" Map jj to esc in insert mode. Esc is too far away.
inoremap jj <C-C>

" H -> start of line, L -> end of line
nnoremap H ^
nnoremap L $

" When would I ever want this? Tip: the answer is FUCKING NEVER
nnoremap q: <nop>

" F1: Disabled. If I want help, I'll use :help, tyvm.
Map <silent> <F1> <nop>

" F4: Clear the highlighting of the current search.
Map <silent> <F4> :noh<CR>

" F5: Toggle paste mode.
Map <silent> <F5>
  \ :let &paste = !&paste <Bar>
  \ if exists('oldshowbreak') <Bar>
  \   let &showbreak = oldshowbreak <Bar>
  \   unlet oldshowbreak <Bar>
  \ else <Bar>
  \   let oldshowbreak = &showbreak <Bar>
  \   set showbreak= <Bar>
  \ endif <CR>
set pastetoggle=<F5>

" Just... don't.
nnoremap <S-K> <nop>
