########################################################################################################################
# The "pipeline" system.
#
# Most fzf commands can be seen as three components: the source data, the preview, and the output. To make it easy to
# mix and match these, these will be defined as three separate commands.
#
# The source will be defined as a command named _fzf_pipeline_NAME_source. It may accept arguments, and it should output
# the data to be piped into fzf. The first word of each line serves as identifier, it will not be shown in fzf, and will
# be available to most commands.
#
# The preview will be defined as a command named _fzf_pipeline_NAME_preview. It will receive two arguments: the
# identifier of the selected line in fzf, and the rest of the selected line. It should output the data to be shown
# as preview. It is optional, and if it is not present no preview will be shown for this pipeline.
#
# The output will be defined as a command named _fzf_pipeline_NAME_target. It will receive two arguments: the identifier
# of the chosen line in fzf, and the rest of the selected line. It should output the final output of the pipeline,
# which will be printed to stdout. It is optional, and if it is not present the identifier will be output.
########################################################################################################################

(
    # Example pipeline
    _fzf_pipeline_example_source() {
        echo "1 Foo"
        echo "2 Bar"
        echo "3 Foo Bar"
    }
    _fzf_pipeline_example_preview() {
        echo "ID: $1"
        echo "Name: $2"
    }
)

_fzf_pipeline_default_target() {
    echo ${(q)1}
}

########################################################################################################################
# Pipeline running
#
# The default way to run pipelines is to use the commands defined here to build a "pipeline config", which is then piped
# into one of the run commands.
########################################################################################################################

FZF_PIPELINE_DEFAULT_ARGS='--ansi'
FZF_SEPERATOR_PLACEHOLDER="\0"

# Add a pipeline to a pipeline config.
#
# The first argument is the name of the pipeline, as documented at the start of this file.
# 
# The second argument is the prefix. All lines of a pipeline will be prefixed with the prefix. This is optional.
_fzf_config_add() {
    local existing pipeline prefix sourcefn targetfn previewfn

    # Store the existing config data if piped into
    if [[ ! -t 0 ]]; then
        read -r existing
    fi

    # Read the arguments
    pipeline="$1"
    shift 1
    if [[ -n "$1" ]]; then
        prefix="$1"
        shift 1
    fi
    if [[ -n "$@" ]]; then
        echo "Extra arguments given to _fzf_config_add ($@)" >&2
        return 1
    fi

    # Validate the arguments and find the functions to use
    if [[ "$pipeline" == *" "* ]]; then
        echo "fzf pipeline names cannot contain spaces ($pipeline)" >&2
        return 1
    fi

    sourcefn="_fzf_pipeline_${pipeline}_source"
    if ! which $sourcefn &> /dev/null; then
        echo "$sourcefn must be a command" >&2
        return 1
    fi

    targetfn="_fzf_pipeline_${pipeline}_target"
    if ! which $targetfn &> /dev/null; then
        targetfn="_fzf_pipeline_default_target"
    fi

    previewfn="_fzf_pipeline_${pipeline}_preview"
    if ! which $previewfn &> /dev/null; then
        previewfn=
    fi
    # Aliases don't seem to work correctly in the previews, so resolve them
    previewfn=$(resolve_alias "$previewfn")

    echo $existing $pipeline ${(q)prefix} $sourcefn $targetfn $previewfn
}

# Get the config of a single pipeline for a pipeline config
#
# The first argument is the pipeline to get the config for
_fzf_config_get() {
    local config pipeline prefix sourcefn targetfn previewfn

    # Read the config
    read -r config

    # Find the correct pipeline
    for pipeline prefix sourcefn targetfn previewfn in ${(z)config}; do
        [[ "$1" == "$pipeline" ]] || continue
        echo $prefix $sourcefn $targetfn $previewfn
        return
    done
    echo "Pipeline $1 not in config" >&2
    return 1
}

# Debug
_fzf_config_debug() {
    local config pipeline prefix sourcefn targetfn previewfn

    # Read the config
    read -r config

    # Output debug info
    for pipeline prefix sourcefn targetfn previewfn in ${(z)config}; do
        (
            echo '--------------------------------------------------------------------------------' >&2
            echo pipeline
            echo "\tvalue: '$pipeline'"
            echo prefix
            echo "\tquoted: '$prefix'"
            echo "\tunquoted: '${(Q)prefix}'"
            echo sourcefn
            echo "\tvalue: '$sourcefn'"
            echo targetfn
            echo "\tvalue: '$targetfn'"
            echo previewfn
            echo "\tvalue: '$previewfn'"
        ) >&2
    done
}

# Get the combined output of all sources of a pipeline config.
#
# This serves as input for fzf when the config is ran.
_fzf_config_get_source() {
    local config pipeline prefix sourcefn targetfn previewfn

    # Read the config
    read -r config

    # Output all source lines
    for pipeline prefix sourcefn targetfn previewfn in ${(z)config}; do
        if [[ -n "$prefix" ]]; then
            prefix="$prefix "
        fi
        $(resolve_alias $sourcefn) | while read -r line; do
            line=(${(z)line})
            echo "$pipeline ${line[1]// /FZF_SEPERATOR_PLACEHOLDER} ${(Q)prefix}${line[2,-1]}"
        done
    done
}

# Run a pipeline config.
#
# Arguments are passed to fzf.
_fzf_config_run() {
    local config pipeline prefix sourcefn targetfn previewfn sources line has_preview fzf_args

    # Read the config
    read -r config

    # Get all source lines
    sources=$(echo ${(z)config} | _fzf_config_get_source)

    # Determine if a preview is needed
    has_preview=0
    for pipeline prefix sourcefn targetfn previewfn in ${(z)config}; do
        [[ -n "${previewfn}" ]] && has_preview=1
    done

    # Build the arguments
    # Default arguments
    fzf_args=(${(z)FZF_PIPELINE_DEFAULT_ARGS})
    # First item of a line is the pipeline, second is identifier, anything beyond that is displayed
    fzf_args=("${fzf_args[@]}" "--with-nth" "3..")
    if [[ $has_preview -eq 1 ]]; then
        fzf_args=(
            "${fzf_args[@]}"
            "--preview" "
                source ~/.zsh/rc/functions.zsh;
                source ~/.zsh/rc/fzf.zsh;
                echo ${(q)config} | _fzf_config_preview {}
            "
            "--preview-window" "down"
        )
    fi
    # Extra arguments
    if [[ -n "$@" ]]; then
        fzf_args=("${fzf_args[@]}" "$@")
    fi

    # Run fzf
    echo $sources | fzf "${fzf_args[@]}" | while read -r line; do
        [[ -n "$line" ]] || return

        # Use the appropriate target function to transform the line
        for pipeline prefix sourcefn targetfn previewfn in ${(z)config}; do
            [[ "$line" == "$pipeline "* ]] || continue

            # Transform the line using this pipeline
            prefix=$(echo ${(Q)prefix})
            line=(${(z)line})
            $(resolve_alias $targetfn) "${line[2]//FZF_SEPERATOR_PLACEHOLDER/ }" "${${line[3,-1]}#${(Q)prefix} }"
            continue 2
        done

        # Unable to match line to pipeline, so fail
        echo "Unable to process output" >&2
        return 1
    done
}

# Render a preview using a pipeline config.
_fzf_config_preview() {
    local config pipeline prefix sourcefn targetfn previewfn line

    # Read the config
    read -r config

    # Get the current line
    line="$1"
    shift 1
    if [[ -n "$@" ]]; then
        echo "Extra arguments given to _fzf_config_preview ($@)" >&2
    fi

    # Use the appropriate preview function
    for pipeline prefix sourcefn targetfn previewfn in ${(z)config}; do
        [[ "$line" == "$pipeline "* ]] || continue
        [[ "${previewfn}" == "" ]] && break;

        # Run the preview
        prefix=$(echo ${(Q)prefix})
        line=(${(z)line})
        ${(z)previewfn} "${line[2]//FZF_SEPERATOR_PLACEHOLDER/ }" "${${line[3,-1]}#${(Q)prefix} }"
        return
    done
    echo "No preview available" >&2
    return 1
}

########################################################################################################################
# Utility methods for simple cases
########################################################################################################################

# Run a single pipeline.
#
# The first argument should be the name of the pipeline.
# Extra arguments are passed to fzf.
fzf_run_pipeline() {
    local pipeline
    pipeline="$1"
    shift 1
    echo | _fzf_config_add "$pipeline" | _fzf_config_run "$@"
}
