autoload -U is-at-least

if ! is-at-least 4.3.11; then
	return 1
fi

source ~/.zsh/bundle/fast-syntax-highlighting/fast-syntax-highlighting.plugin.zsh

fast-theme -q XDG:overlay
