if [ -z "$key_info[Escape]" ] || [ -z "$key_info[Control]" ]; then
	return 1;
fi

# Keybind to restart zsh
restart-zsh() {
	LBUFFER="exec zsh"
	RBUFFER=
	zle accept-line
}
zle -N restart-zsh
bindkey "$key_info[Escape]$key_info[Control]" restart-zsh

