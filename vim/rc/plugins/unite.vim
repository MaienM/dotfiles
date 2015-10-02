" Part of my modulized vimrc file.
" Last change: Tue, 19 Aug 2014 00:12:50 +0200

" Default matcher and sorter. {{{1
call unite#filters#matcher_default#use(['matcher_fuzzy'])
call unite#filters#sorter_default#use(['sorter_length', 'sorter_rank'])

" Ignore certain files/folders. {{{1
let s:ignores = [
  \'build/',
  \'bower_components/',
  \'cache/',
  \'doc/',
  \'node_modules/',
  \'tmp/',
  \'.svn',
  \'.git',
  \'.hg',
  \'.tox',
  \'*.egg',
  \'*.egg-info',
  \'*.pyc',
  \'*~',
  \'.*sw.[po]',
  \'.*un~',
\]

" Convert globs to regexes. {{{2
function! s:to_regex(globs)
  let l:patterns = []
  for l:glob in a:globs
    let l:glob = substitute(l:glob, '[.~]', '\\&', 'g')
    let l:glob = substitute(l:glob, '\*', '.*', 'g')
    let l:patterns = l:patterns + [l:glob]
  endfor
  return join(l:patterns, '\|')
endfunction

" File name search. {{{1
call unite#custom_source('file_rec/async', 'ignore_pattern', s:to_regex(s:ignores))
call unite#custom_source('file_rec/async', 'sorters', ['sorter_rank'])
nnoremap <Leader>f :<C-u>Unite -buffer-name=files -start-insert file_rec/async:!<CR>

" Buffer switching. {{{1
nnoremap <Leader>b :<C-u>Unite -buffer-name=buffers -quick-match buffer<CR>

" Grep. {{{1
if executable('ag')
  let g:unite_source_grep_command = 'ag' " Is faster than ack/grep, and respects .gitignore files.
  let g:unite_source_grep_default_opts = '-in --nocolor --noheading'
else
  echoe "The 'ag' executable seems to be missing. Please install the 'silversearcher-ag' package to increase search performance."
end
call unite#custom_source('grep', 'ignore_pattern', s:to_regex(s:ignores))
nnoremap <Leader>/ :<C-u>Unite -buffer-name=grep grep:!<CR>

" Yanks. {{{1
let g:unite_source_history_yank_enable = 1
call unite#custom#source('history/yank', 'sorters', 'sorter_nothing')
nnoremap <Leader>p :<C-u>Unite -buffer-name=yank history/yank<CR>

" Some settings for unite buffers. {{{1
autocmd FileType unite call s:settings()
function! s:settings()
  " No supertab. {{{2
  let b:SuperTabDisabled=1

  " Moving up and down. {{{2
  imap <buffer> <C-j> <Plug>(unite_select_next_line)
  imap <buffer> <C-k> <Plug>(unite_select_previous_line)

  " Some mappings to open splits/tabs. {{{2
  imap <silent><buffer><expr> <C-x> unite#do_action('split')
  imap <silent><buffer><expr> <C-v> unite#do_action('vsplit')
  imap <silent><buffer><expr> <C-t> unite#do_action('tabopen')

  " So I can spam C-C to get out, now. {{{2
  nmap <buffer> <C-C> <Plug>(unite_exit)
endfunction

" Easily moving though unite matches.
nnoremap <Leader>. :<C-u>UniteNext<CR>
nnoremap <Leader>, :<C-u>UnitePrevious<CR>
