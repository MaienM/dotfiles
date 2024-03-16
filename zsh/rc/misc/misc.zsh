alias zmv='noglob zmv'
alias zcp='noglob zmv -C'
alias zln='noglob zmv -L'

if [[ $commands[du] ]]; then
	function duh() {
		du -maxd 1 -h "$@" | sort -h
	}
fi

if [[ $commands[ts] ]]; then
	# shorthand for commonly used ts format.
	alias tss='ts "[%H:%M:%.S]"'
fi

if [[ $commands[xclip] ]]; then
	# x selection to clipboard (and vice versa).
	alias xsc='xclip -out | xclip -in -selection Clipboard'
	alias xcs='xclip -out -selection Clipboard | xclip -in'

	# transform clipboard contents.
	function xst() {
		xclip -out | "$@" | xclip -in
	}
	function xct() {
		xclip -out -selection clipboard | "$@" | xclip -in -selection clipboard
	}
fi

if [[ $commands[xprop] ]]; then
	# xprop, stripping the icon from the output
	alias xpropni="xprop | awk -vskip=0 '{ if (/^\S/) { skip = 0 }; if (/^_NET_WM_ICON/) { skip = 1 }; if (skip != 1) { print } }'"
fi

