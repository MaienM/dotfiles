if [ -z "$key_info[Escape]" ]; then
	return 1;
fi

# Use a more flexible push-line
bindkey "$key_info[Escape]q" push-line-or-edit

