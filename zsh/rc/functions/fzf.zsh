# The "pipeline" system.
#
# Most fzf commands can be seen as three components: the source data, the preview, and the output. To make it easy to
# mix and match these, these will be defined as three separate commands.
#
# The source will be defined as a command named _fzf_pipeline_NAME_source. It may accept arguments, and it should output
# the data to be piped into fzf.
#
# The preview will be defined as a command named _fzf_pipeline_NAME_preview. It receives a single argument: the selected
# line in fzf, and it should output the data to be shown as preview. It is optional, and if it is not present no preview
# will be shown for this pipeline.
#
# The output will be defined as a command named _fzf_pipeline_NAME_target. It will receive no arguments, but the chosen
# line will be piped into this command. It should output the final output of the pipeline, which will be printed to
# stdout. It is optional, and if it is not present the entire selected line will be used.

(
    # Example pipeline
    _fzf_pipeline_example_source() {
        echo "1 Foo"
        echo "2 Bar"
        echo "3 Foo Bar"
    }
    _fzf_pipeline_example_preview() {
        echo "ID: $(echo "$@" | cut -d' ' -f1)"
        echo "Name: $(echo "$@" | cut -d' ' -f2-)"
    }
    alias _fzf_pipeline_example_target='cut -d" " --f1'
)

################################################################################

# Run a single pipeline.
#
# The first argument should be the name of the pipeline.
# Extra arguments are passed to fzf.
_fzf_run() {
    local pipeline

    pipeline="$1"
    shift 1

    _fzf_multi_start | _fzf_multi_add "$pipeline" "" | _fzf_multi_run "$@"
}

# Start a multi pipeline config
alias _fzf_multi_start='echo'

# Add a pipeline to a multi pipeline config.
#
# The first argument is the name of the pipeline, as documented at the start of this file.
# 
# The second argument is the prefix. All lines of a pipeline will be prefixed with the prefix. This is required, as it
# is used to identify the type in order to use the correct preview/target command.
_fzf_multi_add() {
    local existing pipeline prefix sourcefn targetfn previewfn

    # Store the existing config data
    read -r existing

    # Read the arguments
    pipeline="$1"
    prefix="$2"
    shift 2
    if [[ -n "$@" ]]; then
        echo "Extra arguments given to _fzf_multi_add ($@)" >&2
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
        targetfn="cat"
    fi

    previewfn="_fzf_pipeline_${pipeline}_preview"
    if ! which $previewfn &> /dev/null; then
        previewfn=
    fi

    echo $existing ${(q)pipeline} ${(q)prefix} ${(q)sourcefn} ${(q)targetfn} ${(q)previewfn}
}

# Debug
_fzf_multi_debug() {
    local config pipeline prefix sourcefn targetfn previewfn

    # Read the config
    read -r config

    # Output debug info
    for pipeline prefix sourcefn targetfn previewfn in ${(z)config}; do
        (
            echo '--------------------------------------------------------------------------------' >&2
            echo pipeline
            echo "\tquoted: '$pipeline'"
            echo "\tunquoted: '${(Q)pipeline}'"
            echo prefix
            echo "\tquoted: '$prefix'"
            echo "\tunquoted: '${(Q)prefix}'"
            echo sourcefn
            echo "\tquoted: '$sourcefn'"
            echo "\tunquoted: '${(Q)sourcefn}'"
            echo targetfn
            echo "\tquoted: '$targetfn'"
            echo "\tunquoted: '${(Q)targetfn}'"
            echo previewfn
            echo "\tquoted: '$previewfn'"
            echo "\tunquoted: '${(Q)previewfn}'"
        ) >&2
    done
}

# Run a multi pipeline config.
#
# Arguments are passed to fzf.
_fzf_multi_run() {
    local config pipeline prefix sourcefn targetfn previewfn sources line target has_preview fzf_args

    # Read the config
    read -r config

    # Get all source lines
    sources=$(
        for pipeline prefix sourcefn targetfn previewfn in ${(z)config}; do
            ${(Q)sourcefn} | while read line; do echo "${(Q)prefix}$line"; done
        done
    )

    # Determine if a preview is needed
    has_preview=0
    for pipeline prefix sourcefn targetfn previewfn in ${(z)config}; do
        [[ -n "${(Q)previewfn}" ]] && has_preview=1
    done

    # Run FZF
    fzf_args=("--ansi")
    if [[ $has_preview -eq 1 ]]; then
        fzf_args=(
            "${fzf_args[@]}"
            "--preview" "source ~/.zsh/rc/functions.zsh; echo ${(q)config} | _fzf_multi_preview {}"
            "--preview-window" "down"
        )
    fi
    echo $sources | fzf $fzf_args "$@" | read -r target || return

    # Use the appropriate target function to transform the line
    for pipeline prefix sourcefn targetfn previewfn in ${(z)config}; do
        prefix=$(echo ${(Q)prefix} | stripescape)
        [[ "$target" == "${prefix}"* ]] || continue

        # Transform the line using this pipeline
        echo "${target#${prefix}}" | ${(Q)targetfn}
        return
    done
    echo "Unable to process output" >&2
    return 1
}

# Render a preview using a multi pipeline config.
_fzf_multi_preview() {
    local config pipeline prefix sourcefn targetfn previewfn line

    # Read the config
    read -r config

    # Get the current line
    line="$1"
    shift 1
    if [[ -n "$@" ]]; then
        echo "Extra arguments given to _fzf_multi_preview ($@)" >&2
    fi

    # Use the appropriate preview function
    for pipeline prefix sourcefn targetfn previewfn in ${(z)config}; do
        prefix=$(echo ${(Q)prefix} | stripescape)
        [[ "$line" == "${prefix}"* ]] || continue
        [[ "${(Q)previewfn}" == "" ]] && break;

        # Run the preview
        ${(Q)previewfn} "${line#${prefix}}"
        return
    done
    echo "No preview available"
}
