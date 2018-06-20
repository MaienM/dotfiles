if [ -z "$key_info[Control]" ]; then
	return 1;
fi

# Easily complete using presets
fzf_complete_preset() {
    local prefix result
    prefix=${${(zA)LBUFFER}[-1]}
    result=$(fzf_run_preset "$prefix" --height='30%' --preview-window='right') || return 1
    LBUFFER="${LBUFFER%$prefix}$result"
}
zle -N fzf_complete_preset
for key in "$key_info[Control]"{e,E}; do
	bindkey "$key" fzf_complete_preset
done
