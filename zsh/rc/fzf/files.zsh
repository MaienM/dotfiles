# A utility function that displays relevant information for a filesystem item. Useful for previews.
_fzf_util_inspect_fs_item() {
    fn="$1"
    if [ -d "$fn" ]; then
        ls -hl "$fn"
    elif [ -f "$fn" ]; then
        pygmentize -g -O "full,style=$BASE16_THEME" "$fn"
    else
        stat "$fn"
    fi
}
