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

