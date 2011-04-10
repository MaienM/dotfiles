" Part of my modulized vimrc file.
" Last change: Wed, 16 Mar 2011 15:40:12 +0100

au BufNewFile *.* exe ':silent! 0read '.findfile('templates/'.expand('<afile>:e'),&runtimepath) | $
