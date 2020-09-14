[ -e "$HOME/.asdf/plugins/direnv" ] || return

# Add to path, in case asdf was not yet setup.
append_to_path "$HOME/.asdf/bin"

# Remove shims and function, in case asdf was setup.
remove_from_path "$HOME/.asdf/shims"
[ "$(type -w asdf)" = "asdf: function" ] && unfunction asdf

eval "$(asdf exec direnv hook zsh)"
