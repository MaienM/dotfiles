# Commits
_fzf_pipeline_git_commit_source() {
    git log --pretty=format:"%H ${fg[yellow]}%h$reset_color %s" "$@"
}
_fzf_pipeline_git_commit_preview() {
    git show --name-status "$1"
}

# Branches
_fzf_pipeline_git_branch_source() {
    # Get all branches, local and remote, with their full name.
    # Filter out remote branches that have the same name and HEAD as another branch (local or remote).
    local __ branch columns name commit
    columns=$(($COLUMNS / 5))
    git branch --all "$@" \
    | grep -v HEAD \
    | sed 's/^[[:space:]*]*//' \
    | while read branch; do
        # Output format: branch_full remote_name branch_name commit_hash
        echo -n ${branch#remotes/}
        if [[ "$branch" == "remotes/"* ]]; then
            echo -n ' '${${branch#remotes/}%/*}
        else
            echo -n ' !!!!!local'
        fi
        echo -n ' '${branch#remotes/*/}
        echo -n ' '$(git rev-parse "$branch")
        echo
    done \
    | sort --key=2 \
    | sort --key=4 --stable \
    | sort --key=3 --stable \
    | uniq --skip-fields=2 \
    | sort --key=2 --stable \
    | while read branch __ __ __; do
        echo -n $branch
        echo -n ' '${fg[yellow]}${branch[0,$columns]}$reset_color
        echo -n ' | '$(git log --pretty=format:%s "$branch" --max-count=1)
        echo
    done \
    | column --table --separator='|' --output-separator=''
}
alias _fzf_pipeline_git_branch_preview='_fzf_pipeline_git_commit_preview'
_fzf_pipeline_git_branch_target() {
    local short

    # Abbreviate the name, if it is non-ambiguous
    short=${1#*/}
    if [[ $(git branch --list --all | grep "$short" | wc -l) -eq 1 ]]; then
        echo $short
    else
        echo $1
    fi
}

# Tags
_fzf_pipeline_git_tag_source() {
    git tag "$@" --format="%(refname:strip=1) ${fg[yellow]}%(refname:strip=2)$reset_color %(subject)"
}
alias _fzf_pipeline_git_tag_preview='_fzf_pipeline_git_commit_preview'

# Presets
alias _fzf_preset_git_commit='_fzf_config_add git_commit'
alias _fzf_preset_git_branch='_fzf_config_add git_branch'
alias _fzf_preset_git_tag='_fzf_config_add git_tag'
_fzf_preset_git_ref() {
    echo \
    | _fzf_config_add "git_branch" "${fg[green]}branch$reset_color" \
    | _fzf_config_add "git_tag" "${fg[blue]}tag$reset_color" \
    | _fzf_config_add "git_commit" "${fg[cyan]}commit$reset_color"
}

_fzf_register_preset "git_commit" "Git commits" "git:commit"
_fzf_register_preset "git_branch" "Git branches" "git:branch"
_fzf_register_preset "git_tag" "Git tags" "git:tag"
_fzf_register_preset "git_ref" "Git refs (commits, branches and tags)" "git:ref"
