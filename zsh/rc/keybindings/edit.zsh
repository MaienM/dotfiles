if [ -z "$key_info[Escape]" ]; then
	return 1;
fi

autoload edit-command-line
zle -N edit-command-line

# Edit the current command in $EDITOR.
for key in "$key_info[Escape]"{i,I}; do
	bindkey "$key" edit-command-line
done
