
_fzf_complete_stuff() {
    _fzf_run_complete_prefix "$prefix" "$@"
}

########################################################################################################################
# Prefix running
#
# By default, the completion will try to determine what should be completed by using the context. However, by using a
# prefix this can be overridden.
#
# Example: git:commit:**<Tab> will autocomplete git commits, regardless of the context. While performing a git related
# command, commit:**<Tab> will do the same, if the completion of the git command is setup correctly.
