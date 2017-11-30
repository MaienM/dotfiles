let g:tmuxline_preset = {
	\'a':    '#S',
	\'win':  [
		\'#I',
		\'#W',
	\],
	\'cwin': [
		\'#I',
		\'#W',
	\],
	\'x': '#(~/.tmux/scripts/battery.sh)',
	\'y':    [
		\'%Y-%m-%d',
		\'%H:%M',
	\],
	\'z':    '#H',
	\'options': {
		\'status-justify': 'left',
	\},
\}
