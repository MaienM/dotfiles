# Find directories
_fzf_pipeline_directories_source() {
    local fn
    find . -type d -print | while read -r fn; do
        echo "${(q)fn} $fn";
    done
}
_fzf_pipeline_directories_preview() {
    ls --color --almost-all --ignore-backups --group-directories-first --human-readable --format=long ${(Q)1}
}
_fzf_pipeline_directories_target() {
    echo ${(Q)1}
}

# Find parent directories
_fzf_pipeline_parent_directories_source() {
    local cwd

    cwd="$PWD"
    while [[ $cwd != '/' ]]; do
        cwd=$(cd "$cwd/.."; pwd)
        echo "${(q)cwd} $cwd"
    done
}
alias _fzf_pipeline_parent_directories_preview=_fzf_pipeline_directories_preview
alias _fzf_pipeline_parent_directories_target=_fzf_pipeline_directories_target

# Presets
alias _fzf_preset_directories='_fzf_config_add directories'
alias _fzf_preset_parent_directories='_fzf_config_add parent_directories'

_fzf_register_preset "directories" "Directories" "directories"
_fzf_register_preset "parent_directories" "Parent directories" "directories:parent"

# Aliases
bd() {
    local result
    fzf_run_preset "directories:parent" | read -r result || return
    cd $result
}
