# Some shortcuts.
alias gits='rm -f \\ && git status'

# Log.
alias gitlv='git log --oneline --name-status'
alias gitlvu='gitlv origin/master..'

# Rebasing.
alias gitrb='git rebase --interactive'
alias gitrbu='gitrb origin/master..'

# Get the jira item from a branch name
alias _git_branch_to_jira="sed 's/\\(-[0-9]\\+\\).*$/\\1/g'"

# A variant of git diff that also shows diffs for new and deleted files
gitd() {
    local opts

    opts=()
    if [[ "$@" == *' -- '* ]]; then
        while ! [ "$1" = '--' ]; do
            opts=("${opts[@]}" "$1")
            shift 1
        done
    fi

    for file in "$@"; do
        if [[ -n "$(git ls-files "$file")" ]]; then
            git diff "${opts[@]}" -- "$file"
        else
            git diff "${opts[@]}" --no-index -- /dev/null "$file"
        fi
    done
}

# Diff + add.
gitda() {
    if [[ $# -eq 0 ]]; then
        files=($(fzf_run_preset \
            "git:files:dirty" \
            --multi \
            --header="Pick files to stage" \
            --bind='alt-p:abort+execute(git add -p {2} >&2 < /dev/tty)' \
        ))
        [ ${#files} -gt 0 ] || return 0
        git add "${files[@]}"
    else
        gitd $@
        prompt_confirm "Add to index?" "Y" && git add $@
    fi
    gits
}

# Checkout
gitco() {
    # Determine files to operate on
    files=()
    if [[ $# -eq 0 ]]; then
        files=($(fzf_run_preset \
            "git:files:dirty" \
            --multi \
            --header="Pick files to checkout" \
            --bind='alt-p:abort+execute(git checkout -p {2} >&2 < /dev/tty)' \
        ))
        [ ${#files} -gt 0 ] || return 0
        echo "Picked files:"
        printf "\t$color_fg_cyan%s$color_reset\n" "${files[@]}"
    else
        files=("$@")
        gitd $@
    fi
    prompt_confirm "Reset changes? ${color_fg_red}This is not reversible!$color_reset" "n" || return 0

    # Reset the changes
    for file in "${files[@]}"; do
        if [[ -n "$(git ls-files "$file")" ]]; then
            git checkout -- "$file"
        else
            rm "$file"
        fi
    done

    gits
}

# Commit
gitcj() {
    local preset
    if [[ -z $1 ]]; then
        echo "Please add a commit message!"
        exit 1
    fi
    preset=$(git rev-parse --abbrev-ref HEAD)
    preset=${preset#remotes/*/}
    preset=$(echo $preset | _git_branch_to_jira)
    git commit -m "$preset: $@"
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
