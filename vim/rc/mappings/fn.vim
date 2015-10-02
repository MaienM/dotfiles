" Part of my modulized vimrc file.
" Last change: Sat, 24 Mar 2012 17:14:10 +0100

" F1-F4: Mappings to assist lazy me in being lazy.
" F1: Disabled. If I want help, I'll use :help, tyvm.
Map <silent> <F1> <nop>

" F4: Clear the highlighting of the current search.
Map <silent> <F4> :noh <CR>

" F5-F8: Stuff that edits/alters/works on the current file in any way.
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

