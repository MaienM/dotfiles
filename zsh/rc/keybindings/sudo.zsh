if [ -z "$key_info[Escape]" ]; then
	return 1;
fi

# Easily sudo(edit)
function toggle-sudo {
	# If nothing has been typed, use the last command
	[[ -z $BUFFER ]] && zle up-history

	# Toggle between editing with $EDITOR and with sudoedit.
	if [[ "$BUFFER" == $EDITOR\ * ]]; then
		LBUFFER="sudoedit ${LBUFFER#$EDITOR }"
	elif [[ "$BUFFER" == sudoedit\ * ]]; then
		LBUFFER="$EDITOR ${LBUFFER#sudoedit }"

	# Toggle between running a shell alias regularly and with sudoa.
	elif [[ "$BUFFER" == sudoa\ * ]]; then
		LBUFFER="${LBUFFER#sudoa }"
	elif [[ "${+aliases["${BUFFER%* }"]}" -eq 1 ]]; then
		LBUFFER="sudoa $LBUFFER"

	# Toggle between running a shell function regularly and with sudof.
	elif [[ "$BUFFER" == sudof\ * ]]; then
		LBUFFER="${LBUFFER#sudof }"
	elif [[ "${+functions["${BUFFER%* }"]}" -eq 1 ]]; then
		LBUFFER="sudof $LBUFFER"

	# Toggle between running regularly and with sudo.
	elif [[ "$BUFFER" == sudo\ * ]]; then
		LBUFFER="${LBUFFER#sudo }"
	else
		LBUFFER="sudo $LBUFFER"
	fi
}
zle -N toggle-sudo
bindkey "$key_info[Escape]s" toggle-sudo

