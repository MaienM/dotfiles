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

_fzf_run() {
    local name sourcefn targetfn previewfn target

    name="$1"
    sourcefn="_fzf_pipeline_${name}_source"
    targetfn="_fzf_pipeline_${name}_target"
    previewfn="_fzf_pipeline_${name}_preview"

    # Check the names/functions
    if [[ "$name" == *" "* ]]; then
        echo "fzf pipeline names cannot contain spaces" >&2
        return 1
    fi
    if [[ "$(type $sourcefn)" != *"function"* ]]; then
        echo "$sourcefn must be a function"
        return 1
    fi
    if [[ "$(type $targetfn)" != *"function"* ]]; then
        targetfn="cat"
    fi
    if [[ "$(type $previewfn)" != *"function"* ]]; then
        previewfn=
    fi

    # Build the args for fzf
    fzf_args=("--ansi")
    if [[ -n "$previewfn" ]]; then
        fzf_args=("${fzf_args[@]}" "--preview" "source ~/.zsh/init.zsh; $previewfn {}" "--preview-window" "down")
    fi

    target=$($sourcefn | fzf $fzf_args) || return
    echo "$target" | $targetfn
}
