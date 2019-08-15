if [ -z "$key_info[Escape]" ] || [ -z "$key_info[Control]" ]; then
	return 1;
fi

# Keybind to restart zsh
restart-zsh() {
	BUFFER="exec zsh"
	zle accept-line
}
zle -N restart-zsh
bindkey "$key_info[Escape]$key_info[Control]r" restart-zsh

