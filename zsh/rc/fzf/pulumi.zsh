# stack
_fzf_pipeline_pulumi_stack_urn_source() {
	local match stack
	if ! [[ "$(pulumi config get doesnotexist 2>&1 || true)" =~ "^error: configuration key 'doesnotexist' not found for stack '(.*)'$" ]]; then
		>&2 echo "Cannot determine current pulumi stack."
		return 1
	fi
	stack="${match[1]}"

	jq -r '
		.checkpoint | (.latest // .Latest) | .resources[] |
		.name = (.urn | split("::") | last) |
		.info = @sh "\(.urn) \(.type) \(.name)" |
		"\(.info | @sh) \(.type) \(.name)"
	' \
	< "$HOME/.pulumi/stacks/$stack.json" \
	| sort -u
}
_fzf_pipeline_pulumi_stack_urn_preview() {
	info=("${(z)${(Q)1}}")
	echo "Type: ${(Q)info[3]}"
	echo "Name: ${(Q)info[4]}"
	echo "URN:  ${(Q)info[1]}"
}
_fzf_pipeline_pulumi_stack_urn_target() {
	info=("${(z)${(Q)1}}")
	echo "${(Q)info[1]}"
}

alias _fzf_pipeline_pulumi_stack_targets_source='_fzf_pipeline_pulumi_stack_urn_source'
alias _fzf_pipeline_pulumi_stack_targets_preview='_fzf_pipeline_pulumi_stack_urn_preview'
_fzf_pipeline_pulumi_stack_targets_target() {
	echo --target
	_fzf_pipeline_pulumi_stack_urn_target "$@"
}

alias _fzf_pipeline_pulumi_stack_type_and_name_source='_fzf_pipeline_pulumi_stack_urn_source'
alias _fzf_pipeline_pulumi_stack_type_and_name_preview='_fzf_pipeline_pulumi_stack_urn_preview'
_fzf_pipeline_pulumi_stack_type_and_name_target() {
	info=("${(z)${(Q)1}}")
	echo "${(Q)info[3]} ${(Q)info[4]}"
}

# Presets
alias _fzf_preset_pulumi_stack_urn='_fzf_config_add pulumi_stack_urn'
alias _fzf_preset_pulumi_stack_targets='_fzf_config_add pulumi_stack_targets'
alias _fzf_preset_pulumi_stack_type_and_name='_fzf_config_add pulumi_stack_type_and_name'

_fzf_register_preset "pulumi_stack_urn" "Pulumi stack" "pulumi:stack:urn"
_fzf_register_preset "pulumi_stack_targets" "Pulumi stack" "pulumi:stack:targets"
_fzf_register_preset "pulumi_stack_type_and_name" "Pulumi stack" "pulumi:stack:type_and_name"
