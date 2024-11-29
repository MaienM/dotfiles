" Apply the base16 theme.
if &t_Co > 2 || has('gui_running')
	set t_Co=256
	if !has('nvim')
		set guioptions=0
	endif
	let base16colorspace=256
	if has('termguicolors')
		set termguicolors
	endif
endif
colorscheme base16

" Don't set a background using the theme, falling back on the color set by the terminal. This allows for transparency.
au ColorScheme,VimEnter * hi Normal ctermbg=none
au ColorScheme,VimEnter * hi NonText ctermbg=none

" Customize the look of NeoVim floating windows.
au FileType fzf setlocal nonumber norelativenumber
au ColorScheme,VimEnter * hi NormalFloat ctermbg=18

" Set the font for gvim.
set guifont="Fira Code:h11"
