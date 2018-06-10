#!/bin/sh

if which nvim &> /dev/null; then
    alias vim="echo Use 'nvim' instead. If you _really_ need vim, use 'command vim'"
fi

# Get the definition of an alias
resolve_alias() {
    local args name output retval

    args=(${(z)@})
    name=${args[1]}
    output=$(which "$name")
    retval=$?
    if [[ $retval -eq 0 ]] && [[ $output == "$name: aliased to "* ]]; then
        # Got an alias definition back
        resolve_alias ${output#$name: aliased to }  "${args[2,-1]}"
    else
        # The original input wasn't an alias, so return that
        echo "$@"
    fi
}

# Run a command, and use the results for completion.
#
# The arguments are run as command
run_as_complete() {
    local results

    # Run the command
    $@ | read -r results || return 1

    # Add the results to the buffer
    if [[ -n "$results" ]]; then
        LBUFFER="$LBUFFER$results"
    fi
}
