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
