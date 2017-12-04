# Expands .... to ../..
function expand-dot-to-parent-directory-path {
	if [[ $LBUFFER = *.. ]]; then
		LBUFFER+='/..'
	else
		LBUFFER+='.'
	fi
}
zle -N expand-dot-to-parent-directory-path
bindkey . expand-dot-to-parent-directory-path
