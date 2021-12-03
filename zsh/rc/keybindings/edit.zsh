if [ -z "$key_info[Escape]" ]; then
	return 1;
fi

autoload edit-command-line
zle -N edit-command-line

function edit-command-line-last {
	# If nothing has been typed, use the last command
	[[ -z $BUFFER ]] && zle up-history
	zle edit-command-line
}

zle -N edit-command-line-last

# Edit the current command in $EDITOR.
bindkey "$key_info[Escape]i" edit-command-line-last

