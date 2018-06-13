########################################################################################################################
# The "preset" system.
#
# Pipelines are nice and composable, but a bit of a hassle for most simple scenarios. To make it easy to re-use pipeline
# configs, presets will be used.
#
# Presets are nothing more than a predefined pipeline config, with a name and a description. These can be used from the
# command line easily, either as a command or as completion.
########################################################################################################################

FZF_PRESETS=''

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
        echo "Not enough arguments" >&2
        return 1
    fi

    name=$1
    description=$2
    shift 2

    fn=_fzf_preset_$name
    if ! which $fn &> /dev/null; then
        echo "$fn is not a valid command" >&2
        return 1
    fi

    for preset in $@; do
        FZF_PRESETS="$FZF_PRESETS $preset $fn ${(q)description}"
    done
}

# Pipeline that shows all presets
_fzf_pipeline_fzf_presets_source() {
    local preset fn description

    for preset fn description in ${(z)FZF_PRESETS}; do
        echo "$preset ${fg[cyan]}$preset$reset_color ${(Q)description}"
    done
}
_fzf_pipeline_fzf_presets_preview() {
    local preset fn description
    for preset fn description in ${(z)FZF_PRESETS}; do
        [[ "$preset" == "$1" ]] || continue
        $(resolve_alias $fn) | _fzf_config_get_source | cut -d' ' -f3-
        return
    done
    echo "Unable to preview preset" >&2
    return 1
}

# Run a preset
fzf_run_preset() {
    local match_preset preset fn description

    # First complete on the preset itself, in case it is a partial/nonexistant preset
    if [[ $# -ge 1 ]]; then
        match_preset=${1%:}
        shift 1
    fi
    match_preset=$(fzf_run_pipeline fzf_presets --nth=1 --select-1 --exit-0 --query="$match_preset" "$@") || return 1

    # Complete using the preset 
    for preset fn description in ${(z)FZF_PRESETS}; do
        [[ "$preset" == "$match_preset" ]] || continue
        echo | $(resolve_alias $fn) | _fzf_config_run "$@"
        return
    done
    echo "Unknown preset" >&2
    return 1
}
