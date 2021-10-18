fpath=(
	$HOME/.zsh/rc/completions
	$HOME/.asdf/completions
	$HOME/.zsh/bundle/completion-gradle
	$HOME/.zsh/bundle/completions/src
	$fpath
)

autoload -Uz compinit
compinit

if [[ $commands[kubectl] ]]; then
	source <(kubectl completion zsh)
fi
