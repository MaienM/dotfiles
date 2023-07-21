# stack
_fzf_pipeline_pulumi_stack_urn_source() {
	local i line lines patterns type name attributes info

	i=0

	lines=()
	while read -r line; do
		lines=("${lines[@]}" "$line")
	done < <(pulumi stack -ui)

	patterns=(
		resource '\s*[├└]─\s*(\S+)\s+(\S+)$'
		attribute '\s*│\s*(\S+):\s+(\S+)$'
	)

	parse_line() {
		local name pattern
		for name pattern in "${patterns[@]}"; do
			if [[ "$1" =~ "$pattern" ]]; then
				line=("$name" "${match[@]}")
				return 0
			fi
		done
		return 1
	}

	peek_next() {
		while [ "$i" -lt "${#lines[@]}" ]; do
			if ! parse_line "${lines["$i"]}"; then
				: $((i+=1))
				continue
			fi
			return 0
		done
		return 1
	}

	next() {
		peek_next
		: $((i+=1))
	}

	# Skip until the start of the first resource.
	while peek_next && [ "${line[1]}" != 'resource' ]; do
		next
	done

	while peek_next; do
		next
		type="${line[2]}"
		name="${line[3]}"

		declare -A attributes
		while peek_next && [ "${line[1]}" != 'resource' ]; do
			next
			attributes[${line[2]}]="${line[3]}"
		done
		[ -n "${attributes[URN]}" ] || continue

		info="${(q)attributes[URN]} ${(q)attributes[ID]} ${(q)type} ${(q)name}"
		echo "${(q)info} ${type} ${name}"
	done
}
_fzf_pipeline_pulumi_stack_urn_preview() {
	info=("${(z)${(Q)1}}")
	echo "Type: ${(Q)info[3]}"
	echo "Name: ${(Q)info[4]}"
	echo "URN:  ${(Q)info[1]}"
	echo "ID:   ${(Q)info[2]}"
}
_fzf_pipeline_pulumi_stack_urn_target() {
	info=("${(z)${(Q)1}}")
	echo "${(Q)info[1]}"
}

alias _fzf_pipeline_pulumi_stack_type_and_name_source='_fzf_pipeline_pulumi_stack_urn_source'
alias _fzf_pipeline_pulumi_stack_type_and_name_preview='_fzf_pipeline_pulumi_stack_urn_preview'
_fzf_pipeline_pulumi_stack_type_and_name_target() {
	info=("${(z)${(Q)1}}")
	echo "${(Q)info[3]} ${(Q)info[4]}"
}

if ! command -v pulumi &> /dev/null; then
	return
fi

# Presets
alias _fzf_preset_pulumi_stack_urn='_fzf_config_add pulumi_stack_urn'
alias _fzf_preset_pulumi_stack_type_and_name='_fzf_config_add pulumi_stack_type_and_name'

_fzf_register_preset "pulumi_stack_urn" "Pulumi stack" "pulumi:stack:urn"
_fzf_register_preset "pulumi_stack_type_and_name" "Pulumi stack" "pulumi:stack:type_and_name"
