# Insert 'sudo ' at the beginning of the line
function prepend-sudo {
	if [[ "$BUFFER" != su(do|)\ * ]]; then
		BUFFER="sudo $BUFFER"
		(( CURSOR += 5 ))
	fi
}
zle -N prepend-sudo
for key in "$key_info[Escape]"{s,S}; do
	bindkey "$key" prepend-sudo
done
