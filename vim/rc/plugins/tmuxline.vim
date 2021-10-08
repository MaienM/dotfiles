let s:i_mdi_message_text=''
let s:i_mdi_bell=''
let s:i_mdi_bell_sleep=''
let s:i_mdi_magnify=''
let s:win_flags = [
	\'#{?window_activity_flag, ' . s:i_mdi_message_text . ',}',
	\'#{?window_bell_flag, ' . s:i_mdi_bell . ',}',
	\'#{?window_silence_flag, ' . s:i_mdi_bell_sleep . ',}',
	\'#{?window_zoomed_flag, ' . s:i_mdi_magnify . ',}',
\]

let s:win = [
	\'#I' . join(s:win_flags, ''),
	\'#W',
\]

let g:tmuxline_preset = {
	\'a': '#{?client_prefix,#[fg=colour042],}#S',
	\'win': s:win,
	\'cwin': s:win,
	\'x': '#(prefix= ~/.config/polybar/scripts/watch-with-interrupt.sh updates 3600 ~/.config/polybar/scripts/updates.sh)',
	\'y': '%Y-%m-%d %H:%M',
	\'z': '#H',
	\'options': {
		\'status-justify': 'left',
	\},
\}

" Don't mess with the tmux statusline during runtime, only generate a snapshot for tmux to load.
let g:airline#extensions#tmuxline#enabled = 0
command! TmuxlineUpdate Tmuxline airline <Bar> TmuxlineSnapshot! $HOME/.tmux/tmuxline.conf
