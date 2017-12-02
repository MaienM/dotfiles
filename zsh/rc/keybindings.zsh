# Use human-friendly identifiers
zmodload zsh/terminfo
typeset -gA key_info
key_info=(
	'Control'         '\C-'
	'ControlLeft'     '\e[1;5D \e[5D \e\e[D \eOd'
	'ControlRight'    '\e[1;5C \e[5C \e\e[C \eOc'
	'ControlPageUp'   '\e[5;5~'
	'ControlPageDown' '\e[6;5~'
	'Escape'          '\e'
	'Meta'            '\M-'
	'Up'              "$terminfo[kcuu1]"
	'Left'            "$terminfo[kcub1]"
	'Down'            "$terminfo[kcud1]"
	'Right'           "$terminfo[kcuf1]"
	'BackTab'         "$terminfo[kcbt]"
)

# Set empty $key_info values to an invalid UTF-8 sequence to induce silent bindkey failure
for key in "${(k)key_info[@]}"; do
	if [[ -z "$key_info[$key]" ]]; then
		key_info[$key]='�'
	fi
done

# Load the files defining the keybindings
for file in ~/.zsh/rc/keybindings/*.zsh; do
	source "$file"
done