" Part of my modulized vimrc file.
" Last change: Tue, 13 Mar 2012 20:45:37 +0100

function! Header(title, fill, length)
  let len = str2nr(a:length) - strlen(a:title) - 2
  if len < 1
    return
  endif

  let left = float2nr(ceil(len/2.0))
  let right = len/2

  execute 'normal '.left.'A'.a:fill.'A '.a:title.' '.right.'A'.a:fill.''
endfunction
