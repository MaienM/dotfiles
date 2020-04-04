alias zmv='noglob zmv'
alias zcp='noglob zmv -C'
alias zln='noglob zmv -L'

if command -v xclip > /dev/null 2>&1; then
	# x selection to clipboard (and vice versa).
	alias xsc='xclip -out | xclip -selection Clipboard'
	alias xcs='xclip -out -selection Clipboard | xclip'
fi

# xprop, stripping the icon from the output
alias xpropni="xprop | awk -vskip=0 '{ if (/^\S/) { skip = 0 }; if (/^_NET_WM_ICON/) { skip = 1 }; if (skip != 1) { print } }'"

