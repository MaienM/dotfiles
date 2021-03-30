########################################################################################################################
# The "preset" system.
#
# Pipelines are nice and composable, but a bit of a hassle for most simple scenarios. To make it easy to re-use pipeline
# configs, presets will be used.
#
# Presets are nothing more than a predefined pipeline config, with a name and a description. These can be used from the
# command line easily, either as a command or as completion.
########################################################################################################################

declare -A FZF_PRESETS

# Register a preset
#
# The first argument will be the name of the preset, which is used to determine the function to perform. The format for
# this is _fzf_preset_{name}. This function should setup a pipeline config.
#
# The second argument will be the description of this preset. This is used to show a list of all possible presets.
#
# Each argument after this is a name under which this preset is available.
#
# For example, _fzf_register_preset "git_commit" "Git commits" "git:commit" will register the preset that
# was used as an example earlier.
_fzf_register_preset() {
	local name description fn preset

	if [[ $# -lt 3 ]]; then
		echo >&2 "Not enough arguments"
		return 1
	fi

	name=$1
	description=$2
	shift 2

	fn=_fzf_preset_$name
	if ! which $fn &> /dev/null; then
		echo >&2 "$fn is not a valid command"
		return 1
	fi

	for preset in $@; do
		FZF_PRESETS[$preset]="$fn ${(q)description}"
	done
}

# Pipeline that shows all presets
_fzf_pipeline_fzf_presets_source() {
	local preset data fn description

	for preset data in ${(kv)FZF_PRESETS[@]}; do
		read fn description <<<"$data"
		echo "$preset ${color_fg_cyan}$preset$color_reset ${(Q)description}"
	done | sort
}
_fzf_pipeline_fzf_presets_preview() {
	local fn description
	read fn description <<<"${FZF_PRESETS[${(Q)1}]}"
	if [ -z "$fn" ]; then
		echo >&2 "Unable to preview preset"
		return 1
	fi
	$(resolve_alias $fn) | _fzf_config_get_source | cut -d' ' -f3- | sed 's/^\s\+//'
}

# Run a preset
fzf_run_preset() {
	local preset_name fn description

	# Load/reset colors
	colors

	# If an argument is passed use it as (partial) preset name
	if [[ $# -ge 1 ]]; then
		preset_name=${1%:}
		shift 1
	fi

	# Complete on the preset itself if the preset name is not an exact match
	if [[ -z "${FZF_PRESETS[$preset_name]}" ]]; then
		preset_name=$(fzf_run_pipeline fzf_presets --nth=1 --select-1 --exit-0 --query="$preset_name" "$@") || return 1
	fi

	# Complete using the preset 
	read fn description <<<"${FZF_PRESETS[$preset_name]}"
	[ -n "$fn" ] || return 1
	echo | $(resolve_alias $fn) | _fzf_config_run "$@"
}
