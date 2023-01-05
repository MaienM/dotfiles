" Apply the base16 theme.
if &t_Co > 2 || has('gui_running')
	set t_Co=256
	set guioptions=0
	let base16colorspace=256
	if has('termguicolors')
		set termguicolors
	endif
endif
colorscheme base16

" Don't set a background using the theme, falling back on the color set by the terminal. This allows for transparency.
au ColorScheme * hi Normal ctermbg=none
au ColorScheme * hi NonText ctermbg=none

" Customize the look of NeoVim floating windows.
au FileType fzf setlocal nonumber norelativenumber
au ColorScheme * hi NormalFloat ctermbg=18

" Set the font for gvim.
set guifont="Fira Code:h11"

" Prepare a list of functions to execute when the theme has been (re)loaded.
let g:theme_hooks = []
function! RegisterThemeHook(func)
	call add(g:theme_hooks, a:func)
endfunction
