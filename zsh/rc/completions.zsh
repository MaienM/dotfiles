fpath=(
	$HOME/.asdf/completions
	$HOME/.zsh/bundle/completion-gradle
	$fpath
)

autoload -Uz compinit
compinit
