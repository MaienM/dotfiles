if [ -z "$key_info[Escape]" ]; then
	return 1;
fi

bindkey "$key_info[Escape]?" describe-key-briefly
