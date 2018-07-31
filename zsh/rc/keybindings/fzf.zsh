if [ -z "$key_info[Control]" ]; then
	return 1;
fi

# Easily complete using presets
fzf_complete_preset() {
    local prefix result
    if [[ "$LBUFFER" == "${LBUFFER%[$IFS]}" ]]; then
        # Doesn't end in ifs, so we're treat the currently typed word as a preexisting filter
        prefix=${${(zA)LBUFFER}[-1]}
    fi
    result=$(
        fzf_run_preset \
            "$prefix" \
            --height='30%' \
            --preview-window='right' \
    )
    [[ -n "$result" ]] && LBUFFER="${LBUFFER%$prefix}$result"
    zle redisplay
}
zle -N fzf_complete_preset
for key in "$key_info[Control]"{e,E}; do
	bindkey "$key" fzf_complete_preset
done
