" When a template file exists for a newly created file, insert the template.
au BufNewFile *.* exe ':silent! 0read '.findfile('templates/'.expand('<afile>:e'),&runtimepath) | $
