if [ -z "$key_info[Escape]" ]; then
	return 1;
fi

# Expand command name to full path
bindkey "$key_info[Escape]E" expand-cmd-path

