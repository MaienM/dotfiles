" Default width and height.
let g:goyo_width = 120
let g:goyo_height = '100%'

" Use the textwidth as width.
au OptionSet textwidth let g:goyo_width = v:option_new

" Setup and teardown to make it even more distraction free.
function! s:goyo_enter()
	let s:goyo = 1
	" Hide tmux statusline.
	silent !tmux set status off
	" Zoom the pane.
	silent !tmux list-panes -F '\#F' | grep -q Z || tmux resize-pane -Z
	" Keep current paragraph centered.
	let s:old_scrollof = &scrolloff
	set scrolloff=999
	" Don't show wrap markers.
	let s:old_showbreak = &showbreak
	set showbreak=
	" Enable Limelight.
	Limelight
	" Set old peekaboo size to restore later.
	let s:old_peekaboo_window = g:peekaboo_window
	" Disable auto resizing.
	if exists(b:golden_ratio_resizing_ignored) && b:golden_ratio_resizing_ignored
		let b:old_golden_ratio_resizing_ignored = 1
	else
		let b:old_golden_ratio_resizing_ignored = 0
	endif
	let b:golden_ratio_resizing_ignored = 1
endfunction
function! s:goyo_leave()
	let s:goyo = 0
	silent !tmux set status on
	silent !tmux list-panes -F '\#F' | grep -q Z && tmux resize-pane -Z
	let &scrolloff = s:old_scrollof
	let &showbreak = s:old_showbreak
	Limelight!
	let g:peekaboo_window = s:old_peekaboo_window
	let b:golden_ratio_resizing_ignored = b:old_golden_ratio_resizing_ignored
endfunction
function! s:resized()
	" Increase peekaboo size to use all available empty space.
	let g:peekaboo_window = 'vert bo ' . ((&columns - &textwidth) / 2) . 'new'
endfunction

au User GoyoEnter nested call <SID>goyo_enter()
au User GoyoLeave nested call <SID>goyo_leave()
au VimResized * call <SID>resized()

" Mapping to toggle.
nmap <Leader>Z :Goyo<CR>
