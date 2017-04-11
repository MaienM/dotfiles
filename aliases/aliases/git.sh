# Some shortcuts.
alias gits='git status'

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
gitcb() {
    if [[ -z $1 ]]; then
        echo "Please add a commit message!"
        exit 1
    fi
    git commit -m "$(git rev-parse --abbrev-ref HEAD | sed 's/.*\///') $@"
}

# Push
alias gitp="git push"
gitpb() {
    remote="${1:-origin}"
    [[ -n $1 ]] && shift
    gitp --set-upstream "$@" "$remote" $(git rev-parse --abbrev-ref HEAD)
}

# Branching
gitbdevelop() {
    git checkout -b $1
    gitpb
    git checkout -b $1-develop
    gitpb
}
