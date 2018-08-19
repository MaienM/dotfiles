let s:win_flags = ''
	\ . '#{?window_activity_flag, #(echo $i_mdi_message_text),}'
	\ . '#{?window_bell_flag, #(echo $i_mdi_bell),}'
	\ . '#{?window_silence_flag, #(echo $i_mdi_sleep),}'
	\ . '#{?window_zoomed_flag, #(echo $i_mdi_magnify),}'

let s:win = [
	\'#I' . s:win_flags,
	\'#W',
\]

let g:tmuxline_preset = {
	\'a': '#S',
	\'win': s:win,
	\'cwin': s:win,
	\'x': [
		\'#(uptime --pretty)',
		\'#(cat /proc/loadavg | cut -d" " -f1-3)',
		\'#(~/.tmux/scripts/battery.sh)',
	\],
	\'y': '%Y-%m-%d %H:%M',
	\'z': '#H',
	\'options': {
		\'status-justify': 'left',
	\},
\}

" Don't mess with the tmux statusline during runtime, only generate a snapshot for tmux to load
let g:airline#extensions#tmuxline#enabled = 0
command! TmuxlineUpdate Tmuxline airline <Bar> TmuxlineSnapshot! $HOME/.tmux/tmuxline.conf
