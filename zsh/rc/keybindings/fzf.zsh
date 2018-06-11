if [ -z "$key_info[Control]" ]; then
	return 1;
fi

# Easily complete using presets
fzf_complete_preset() {
    local prefix

    if [[ "$LBUFFER" != *" " ]]; then
        prefix=${${(zA)LBUFFER}[-1]}
    fi

    _fzf_run_as_complete "_fzf_preset_run $prefix" "${LBUFFER%$prefix}"
}
zle -N fzf_complete_preset
for key in "$key_info[Control]"{e,E}; do
	bindkey "$key" fzf_complete_preset
done
