fpath=(
	$HOME/.asdf/completions
	$HOME/.zsh/bundle/completion-gradle
	$fpath
)

autoload -Uz compinit
compinit

if [[ $commands[kubectl] ]]; then
	source <(kubectl completion zsh)
fi
