" Part of my modulized vimrc file.
" Last change: Mon, 19 Mar 2012 20:16:34 +0100

" Jump to the position we were at when we exited.
au BufRead * '"

" Disable backups and undofiles when working on items in a dropbox folder.
function! DisableBackup() 
  setlocal noundofile
  setlocal noswapfile
endfunction

au BufReadPre,BufNewFile ~/Dropbox/* call DisableBackup()
au BufReadPre,BufNewFile ~/Coding/School/OGO/* call DisableBackup()

" Set the filetype to asm for casm files.
au BufRead *.casm set ft=asm


