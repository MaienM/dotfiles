    local opts

    opts=()
    if [[ "$@" == *' -- '* ]]; then
        while ! [ "$1" = '--' ]; do
            opts=("${opts[@]}" "$1")
            shift 1
        done
    fi

            git diff "${opts[@]}" -- "$file"
        elif [[ -L "$file" ]]; then
            # A new symlink. This is not handled correctly by the --no-index git diff, so create a diff manually.
            (
                echo "${color_bold}diff --git a/$file b/$file$color_reset"
                echo "${color_bold}new file mode 120000$color_reset"
                echo "${color_bold}index 0000000..1234567$color_reset"
                echo "${color_bold}--- /dev/null$color_reset"
                echo "${color_bold}+++ b/$file$color_reset"
                echo "${color_fg_cyan}@@ -0,0 +1 @@$color_reset"
                echo "${color_fg_green}$(readlink "$file")$color_reset"
                echo "\ No newline at end of file$color_reset"
            ) | diff-so-fancy
            git diff "${opts[@]}" --no-index -- /dev/null "$file"
        files=($(fzf_run_preset \
            "git:files:dirty" \
            --multi \
            --header="Pick files to stage" \
            --bind='alt-p:abort+execute(git add -p {2} >&2 < /dev/tty)' \
        ))
        [ ${#files} -gt 0 ] || return 0
        git add "${files[@]}"
    # Determine files to operate on
    files=()
        files=($(fzf_run_preset \
            "git:files:dirty" \
            --multi \
            --header="Pick files to checkout" \
            --bind='alt-p:abort+execute(git checkout -p {2} >&2 < /dev/tty)' \
        ))
        files=("$@")
    prompt_confirm "Reset changes? ${color_fg_red}This is not reversible!$color_reset" "n" || return 0

    # Reset the changes
    for file in "${files[@]}"; do
        if [[ -n "$(git ls-files "$file")" ]]; then
            git checkout -- "$file"
        else
            rm "$file"
        fi
    done
