#!/bin/bash

# Some shortcuts.
alias gits='git status'

# Log.
alias gitlv='git log --oneline --name-status'
alias gitlvu='gitlv origin/master..'

# Rebasing.
alias gitrb='git rebase --interactive'
alias gitrbu='gitrb origin/master..'

# Update.
alias gitup='git stash && (git pull --rebase || echo Pull failed) && git stash pop'

# Diff.
function gitd()
{
    GIT_PAGER='less' git diff --minimal $@
    read message
    if [[ -n $message ]];
    then
        git commit $@ -m "$message"
    fi
    gits
}
