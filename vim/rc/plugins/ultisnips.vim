" Part of my modulized vimrc file.
" Last change: Sun, 18 May 2014 11:39:13 +0000

if !has("nvim")
	let g:UltiSnipsUsePythonVersion = 2
	let g:UltiSnipsNoPythonWarning = 1
endif

" let g:UltiSnipsExpandTrigger="<CR>"
" let g:UltiSnipsJumpForwardTrigger="<Tab>"
" let g:UltiSnipsJumpBackwardTrigger="<S-Tab>"

function! UltiSnipsAddLocalDirectory(dir)
	if empty(a:dir)
		return
	endif
	if !exists("b:UltiSnipsSnippetDirectories")
		let b:UltiSnipsSnippetDirectories=g:UltiSnipsSnippetDirectories
	endif
	if index(b:UltiSnipsSnippetDirectories, a:dir) >= 0
		return
	end
	let b:UltiSnipsSnippetDirectories=b:UltiSnipsSnippetDirectories+[a:dir]
endfunction
au BufRead * if !empty(ProjectRootGet()) | exe "call UltiSnipsAddLocalDirectory(ProjectRootGet() . \"/.lvim/UltiSnips\")" | endif
