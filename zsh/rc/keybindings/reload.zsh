if [ -z "$key_info[Escape]" ] || [ -z "$key_info[Control]" ]; then
	return 1;
fi

# Keybind to restart zsh
for key in "$key_info[Escape]$key_info[Control]"{r,R}; do
	bindkey -s "$key" "exec zsh\n"
done
