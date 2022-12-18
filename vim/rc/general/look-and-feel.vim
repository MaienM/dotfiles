" Apply the base16 theme.
if &t_Co > 2 || has('gui_running')
	set t_Co=256
	set guioptions=0
	let base16colorspace=256
endif
colorscheme base16
let g:colors_name = 'base16'

" Don't set a background using the theme, falling back on the color set by the terminal. This allows for transparency.
au ColorScheme * hi Normal ctermbg=none
au ColorScheme * hi NonText ctermbg=none

" Customize the look of NeoVim floating windows.
au FileType fzf setlocal nonumber norelativenumber
au ColorScheme * hi NormalFloat ctermbg=18

" Set the font for gvim.
if has('gui_running')
	set guifont=InconsolataGo Nerd Font:h11
endif
