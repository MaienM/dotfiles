alias zmv='noglob zmv'
alias zcp='noglob zmv -C'
alias zln='noglob zmv -L'

if command -v xclip > /dev/null 2>&1; then
	# x selection to clipboard (and vice versa).
	alias xsc='xclip -out | xclip -selection Clipboard'
	alias xcs='xclip -out -selection Clipboard | xclip'
fi

