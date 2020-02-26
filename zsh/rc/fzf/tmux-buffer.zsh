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

(){
	# Regex based on https://community.helpsystems.com/forums/intermapper/miscellaneous-topics/5acc4fcf-fa83-e511-80cf-0050568460e4.
	# Adjusted to match IPv4 as well (not just nested in IPv6), and to not match '::'.
	local s='(25[0-5]|2[0-4]\d|1\d\d|[1-9]?\d)'
	local ipv4_regex="($s(\.$s){3})"
	local s='[0-9A-Fa-f]{1,4}'
	local ipv6_regex="((($s:){7}($s|:))|(($s:){6}(:$s|$ipv4_regex|:))|(($s:){5}(((:$s){1,2})|:$ipv4_regex|:))|(($s:){4}(((:$s){1,3})|((:$s)?:$ipv4_regex)|:))|(($s:){3}(((:$s){1,4})|((:$s){0,2}:$ipv4_regex)|:))|(($s:){2}(((:$s){1,5})|((:$s){0,3}:$ipv4_regex)|:))|(($s:){1}(((:$s){1,6})|((:$s){0,4}:$ipv4_regex)|:))|(:(((:$s){1,7})|((:$s){0,5}:$ipv4_regex))))"
	_add_fzf_pipeline_tmux_regex "ip" "$ipv6_regex|$ipv4_regex" "IP addresses" "buffer:ips"
}

