" Re-apply the colorscheme. Without doing this, re-loading the vimrc during runtime causes some of the colors to be
" messed up.
function! s:FixColorscheme(timer)
	try
		let l:colorscheme = g:colors_name
	catch /^Vim:E121/
		let l:colorscheme = 'default'
	endtry
	exe 'colorscheme ' . l:colorscheme
	
	for l:Hook in g:theme_hooks
		call l:Hook()
	endfor
endfunction
call timer_start(1, funcref('<SID>FixColorscheme'))
