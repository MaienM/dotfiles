let g:tmuxline_preset = {
	\'a': '#S',
	\'win': [
		\'#I#{s/-//:window_flags}',
		\'#W',
	\],
	\'cwin': [
		\'#I#{s/*//:window_flags}',
		\'#W',
	\],
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
