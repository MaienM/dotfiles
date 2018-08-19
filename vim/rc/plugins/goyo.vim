" Default width and height
let g:goyo_width = 120
let g:goyo_height = '100%'

" Use the textwidth as width
au OptionSet textwidth let g:goyo_width = v:option_new

" Setup and teardown to make it even more distraction free
function! s:goyo_enter()
	" Hide tmux statusline
	silent !tmux set status off
	" Zoom the pane
	silent !tmux list-panes -F '\#F' | grep -q Z || tmux resize-pane -Z
	" Keep current paragraph centered
	let s:old_scrollof=&scrolloff
	set scrolloff=999
	" Enable Limelight
	Limelight
endfunction
function! s:goyo_leave()
	silent !tmux set status on
	silent !tmux list-panes -F '\#F' | grep -q Z && tmux resize-pane -Z
	let &scrolloff=s:old_scrollof
	Limelight!
endfunction

au User GoyoEnter nested call <SID>goyo_enter()
au User GoyoLeave nested call <SID>goyo_leave()

" Mapping to toggle
nmap <Leader>z :Goyo<CR>
