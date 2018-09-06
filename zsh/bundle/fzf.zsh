# Not actually in the bundle folder, as it is used outside of zsh as well
FZF_PATH="$HOME/.fzf"

append_to_path "$FZF_PATH/bin"
[[ $- == *i* ]] && source "$FZF_PATH/shell/completion.zsh" 2> /dev/null
source "$FZF_PATH/shell/key-bindings.zsh"

