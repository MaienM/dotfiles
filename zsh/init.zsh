autoload -Uz is-at-least

# Load plugins
source ~/.zsh/bundle/autosuggestions.zsh
source ~/.zsh/bundle/powerlevel9k/powerlevel9k.zsh-theme
source ~/.zsh/bundle/prezto-history/init.zsh
source ~/.zsh/bundle/syntax-highlighting/fast-syntax-highlighting.plugin.zsh # Should be behind most other plugins
source ~/.zsh/bundle/history-substring-search/zsh-history-substring-search.zsh

# Load the rc files responsible for the rest of the initialisation.
for file in ~/.zsh/rc/*.zsh; do
	source "$file"
done
