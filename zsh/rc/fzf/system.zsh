# Commands
_fzf_pipeline_commands_source() {
	apropos --sections 1,8 '' | sed 's/^\(\S*\)\s*(\S*)\s*-\s*/\1 \1 /'
}
_fzf_pipeline_commands_preview() {
	man "${(Q)1}" \
	| awk '
		BEGIN { found = 0; }
		{
			if (/^DESCRIPTION$/) { found = 1; next }
			if (/^[A-Z]/) { found = 0 }
			if (found) { print }
		}
	' \
	| head -n-1 \
	| sed 's/^\s*//'
}
_fzf_pipeline_commands_target() {
	echo ${(Q)1}
}

# Presets
alias _fzf_preset_commands='_fzf_config_add commands'

_fzf_register_preset "commands" "Commands" "commands"
