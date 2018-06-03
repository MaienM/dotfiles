# Some shortcuts.
alias gits='rm -f \\ && git status'

# Log.
alias gitlv='git log --oneline --name-status'
alias gitlvu='gitlv origin/master..'

# Rebasing.
alias gitrb='git rebase --interactive'
alias gitrbu='gitrb origin/master..'

# Diff.
alias gitd="GIT_PAGER='less' git diff --minimal"

# Get the jira item from a branch name
alias _git_branch_to_jira="sed 's/\\(-[0-9]\\+\\).*$/\\1/g'"

# Diff/add.
gitda() {
    gitd $@
    prompt_confirm "Add to index?" "Y" && git add $@
    gits
}

# Commit
gitcj() {
    local prefix
    if [[ -z $1 ]]; then
        echo "Please add a commit message!"
        exit 1
    fi
    prefix=$(git rev-parse --abbrev-ref HEAD)
    prefix=${prefix#remotes/*/}
    prefix=$(echo $prefix | _git_branch_to_jira)
    git commit -m "$prefix: $@"
}

# Push
alias gitp="git push"
gitpb() {
    local remote
    remote="${1:-origin}"
    [[ -n $1 ]] && shift
    gitp --set-upstream "$@" "$remote" $(git rev-parse --abbrev-ref HEAD)
}

# View status of multiple repositories
gitsdir() {
    (
        echo "DIR | BRANCH | STATUS"
        for dir in *; do
            [[ ! -d "$dir" ]] && continue
            [[ ! -d "$dir/.git" ]] && continue

            pushd "$dir"
            gitbranch="$(git rev-parse --abbrev-ref HEAD)"
            gitstatus="$(git diff --shortstat | tr -cd '[0-9 ]' | awk '{ print $1 " files +" $2 " -" $3 }')"
            popd

            echo "$dir | $gitbranch | $gitstatus"
        done
    ) | column -t -s '|'
}

################################################################################
# FZF
################################################################################

# Commit
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

# Tags
_fzf_pipeline_git_tag_source() {
    git tag "$@" --format="%(refname:strip=1) ${fg[yellow]}%(refname:strip=2)$reset_color %(subject)"
}
alias _fzf_pipeline_git_tag_preview='_fzf_pipeline_git_commit_preview'

# Autocomplete
_fzf_complete_git() {
    # Auto-determine prefix if none is given
    if [[ -z $prefix ]]; then
        local args
        args=(${(z)@})
        case ${args[2]} in
            checkout) prefix='ref:' ;;
            branch) prefix='branch:' ;;
            tag) prefix='tag:' ;;
            *) return ;;
        esac
    fi

    # Get by prefix
    case $prefix in
        c:|commit:) _fzf_pipeline_run_complete "git_commit" "--ansi" "$@" ;;
        b:|branch:) _fzf_pipeline_run_complete "git_branch" "--ansi" "$@" ;;
        t:|tag:) _fzf_pipeline_run_complete "git_tag" "--ansi" "$@" ;;
        r:|ref:)
            _fzf_config_start \
            | _fzf_config_add "git_branch" "${fg[green]}branch$reset_color" \
            | _fzf_config_add "git_tag" "${fg[blue]}tag$reset_color" \
            | _fzf_config_add "git_commit" "${fg[cyan]}commit$reset_color" \
            | _fzf_config_run_complete "--ansi" "$@"
        ;;
    esac
}
