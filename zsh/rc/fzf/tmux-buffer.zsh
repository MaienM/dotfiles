if ! command -v tmux &> /dev/null || ! command -v rg &> /dev/null; then
	return
fi

# Wrapper around the rg results pipeline that performs them on the current tmux buffer instead of a file.

_fzf_pipeline_rg_tmux_source() {
	file="$(mktemp)"
	tmux capture-pane -pJe -t "$TMUX_PANE" -S-999 >! "$file"
	_fzf_pipeline_rg_file_source "$file" "$@"
}
alias _fzf_pipeline_rg_tmux_preview='_fzf_pipeline_rg_file_preview'
alias _fzf_pipeline_rg_tmux_target='_fzf_pipeline_rg_file_target'

# Pipelines based on capturing specific types of data from the current tmux buffer.

_add_fzf_pipeline_tmux_regex() {
	alias _fzf_pipeline_rg_tmux_$1_source="_fzf_pipeline_rg_tmux_source '$2'"
	alias _fzf_pipeline_rg_tmux_$1_preview='_fzf_pipeline_rg_tmux_preview'
	alias _fzf_pipeline_rg_tmux_$1_target='_fzf_pipeline_rg_tmux_target'
	alias _fzf_preset_tmux_$1="_fzf_config_add rg_tmux_$1"
	_fzf_register_preset "tmux_$1" "$3 in current tmux buffer" "tmux:$4"
}

