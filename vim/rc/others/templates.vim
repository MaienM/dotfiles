" Part of my modulized vimrc file.
" Last change: Mon, 19 Mar 2012 20:17:29 +0100

" When a template file exists for a newly created file, insert the template.
au BufNewFile *.* exe ':silent! 0read '.findfile('templates/'.expand('<afile>:e'),&runtimepath) | $
