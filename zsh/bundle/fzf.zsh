FZF_PATH="$HOME/.zsh/bundle/fzf"

if [ -d "$FZF_PATH/bin" ]; then
	append_to_path "$FZF_PATH/bin"
fi

[[ $- == *i* ]] && source "$FZF_PATH/shell/completion.zsh" 2> /dev/null
source "$FZF_PATH/shell/key-bindings.zsh"
