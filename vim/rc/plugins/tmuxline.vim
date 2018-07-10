let g:tmuxline_preset = {
	\'a': '#S',
	\'win': [
		\'#I',
		\'#W',
	\],
	\'cwin': [
		\'#I',
		\'#W',
	\],
	\'x': [
		\'#(uptime --pretty)',
		\'#(cat /proc/loadavg | cut -d" " -f1-3)',
		\'#(~/.tmux/scripts/battery.sh)',
	\],
	\'y': [
        \'#{continuum_status}',
		\'%Y-%m-%d',
		\'%H:%M',
	\],
	\'z': '#H',
	\'options': {
		\'status-justify': 'left',
	\},
\}

" Don't mess with the tmux line runtime, only generate a snapshot for tmux to load
let g:airline#extensions#tmuxline#enabled = 0
command! TmuxlineUpdate Tmuxline airline <Bar> TmuxlineSnapshot! $HOME/.tmux/tmuxline.conf
