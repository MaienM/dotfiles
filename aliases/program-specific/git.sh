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
gitda()
{
    gitd $@
    prompt_confirm "Add to index?" "Y" && git add $@
    gits
}

# Diff/commit.
gitdc()
{
    gitd $@
    read message
    if [[ -n $message ]];
    then
        git commit $@ -m "$message"
    fi
    gits
}
