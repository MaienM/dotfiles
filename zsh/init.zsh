source ~/.profile

# Load version checking function, for version guards in the plugins.
autoload -Uz is-at-least

# Setup completion engine.
autoload -Uz compinit
compinit

source ~/.zsh/bundle/autosuggestions.zsh
source ~/.zsh/bundle/base16.zsh
source ~/.zsh/bundle/fzf-tab.zsh
source ~/.zsh/bundle/fzf.zsh
source ~/.zsh/bundle/histdb/sqlite-history.zsh
source ~/.zsh/bundle/powerlevel10k/powerlevel10k.zsh-theme
source ~/.zsh/bundle/prezto-history/init.zsh

for file in ~/.zsh/rc/*.zsh; do
	source "$file"
done

source ~/.zsh/bundle/syntax-highlighting.zsh # Wraps zle widgets, should be as late as possible.
source ~/.zsh/bundle/history-substring-search.zsh # Must be after syntax highlighting.
