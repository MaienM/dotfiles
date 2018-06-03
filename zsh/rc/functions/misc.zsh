#!/bin/sh

if which nvim &> /dev/null; then
    alias vim="echo Use 'nvim' instead. If you _really_ need vim, use 'command vim'"
fi

# Get the definition of an alias
resolve_alias() {
    # If the input looks like an alias definition, abort to prevent setting an alias accidentally
    if [[ "$@" == *"="* ]]; then
        echo "$@"
        return
    fi

    local output retval
    output=$(alias "$@")
    retval=$?
    if [[ $retval -eq 0 ]]; then
        # Got an alias definition back
        resolve_alias ${output#$@=}
    else
        # The original input wasn't an alias, so return that
        echo "$@"
    fi
}
