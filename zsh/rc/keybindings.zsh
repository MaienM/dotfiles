# Use human-friendly identifiers
zmodload zsh/terminfo
typeset -gA key_info
key_info=(
	'Control'         '\C-'
	'ControlLeft'     '\e[1;5D \e[5D \e\e[D \eOd'
	'ControlRight'    '\e[1;5C \e[5C \e\e[C \eOc'
	'Escape'          '\e'
	'Home'            "$terminfo[khome]"
	'End'             "$terminfo[kend]"
	'Insert'          "$terminfo[kich1]"
	'Delete'          "$terminfo[kdch1]"
	'Up'              "$terminfo[kcuu1]"
	'Left'            "$terminfo[kcub1]"
	'Down'            "$terminfo[kcud1]"
	'Right'           "$terminfo[kcuf1]"
	'BackTab'         "$terminfo[kcbt]" # Shift-tab
)

# Warn on missing keys
for key in "${(k)key_info[@]}"; do
	if [[ -z "$key_info[$key]" ]]; then
		echo "Unable to find escape code for $key, some keybindings may not be available" >&2
	fi
done

# Load the files defining the keybindings
for file in ~/.zsh/rc/keybindings/*.zsh; do
	source "$file"
done
