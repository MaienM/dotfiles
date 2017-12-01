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

# Diff/add.
gitda() {
    gitd $@
    prompt_confirm "Add to index?" "Y" && git add $@
    gits
}

# Commit
alias gitc="git commit -m"
gitcb() {
    if [[ -z $1 ]]; then
        echo "Please add a commit message!"
        exit 1
    fi
    gitc "$(git rev-parse --abbrev-ref HEAD | sed 's/.*\///' | sed 's/-develop$//') $@"
}

# Push
alias gitp="git push"
gitpb() {
    remote="${1:-origin}"
    [[ -n $1 ]] && shift
    gitp --set-upstream "$@" "$remote" $(git rev-parse --abbrev-ref HEAD)
}

# View status of multiple repositories
gitsdir() {
    (
        echo "REPO | BRANCH | STATUS"
        for dir in *; do
            [[ ! -d "$dir" ]] && continue

            pushd "$dir"
            branch="$(git rev-parse --abbrev-ref HEAD)"
            _status="$(git diff --shortstat | tr -cd '[0-9 ]' | awk '{ print $1 " files +" $2 " -" $3 }')"
            popd

            echo "$dir | $branch | $_status"
        done
    ) | column -t -s '|'
}
