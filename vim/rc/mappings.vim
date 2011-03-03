" Part of my modulized vimrc file.
" Last change: Thu, 03 Mar 2011 16:54:58 +0100

" command Map to map and imap at the same time.
command! -nargs=+ -complete=mapping Map 
  \ :let [start; end] = split('<expr> '.<q-args>, printf('\(\s\+\)\(<%s>\)\@!', join(['buffer', 'silent', 'special', 'script', 'expr', 'unique'], '>\|<'))) <Bar>
  \ let start = strpart(start, 7) <Bar>
  \ execute(printf(':map %s', <q-args>)) <Bar>
  \ execute(printf(':imap %s %s <LT>C-O>%s', start, end[0], end[0]))

" load all mappings files.
runtime! rc/mappings/*.vim
