if [ -z "$key_info[Escape]" ]; then
	return 1;
fi

autoload edit-command-line
zle -N edit-command-line

# Use a more flexible push-line
for key in "$key_info[Escape]"{i,I}; do
	bindkey "$key" edit-command-line
done
