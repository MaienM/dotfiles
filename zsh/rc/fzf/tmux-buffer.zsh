if ! command -v tmux &> /dev/null; then
	return
fi

_fzf_pipeline_tmux_buffer_urls_source() {
	tmux capture-pane -pJ -S-500 | extract-url --list | tac | while read -r url; do
		echo "${(q)url} $url"
	done
}

alias _fzf_preset_tmux_buffer_urls='_fzf_config_add tmux_buffer_urls'

_fzf_register_preset "tmux_buffer_urls" "Tmux buffer urls" "tmux:buffer:urls"
