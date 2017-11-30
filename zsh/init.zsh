# Version check
version() {
	echo "$@" | sed 's/[0-9]\+/00&/g' | sed 's/[0-9]\+\([0-9]\{3\}\)/\1/g' | tr -d '.'
}

# Load plugins
source ~/.zsh/bundle/powerlevel9k/powerlevel9k.zsh-theme
[ $(version $ZSH_VERSION) -ge $(version 5.0.8) ] && \
	source ~/.zsh/bundle/autosuggestions/zsh-autosuggestions.zsh
source ~/.zsh/bundle/prezto-history/init.zsh
source ~/.zsh/bundle/syntax-highlighting/zsh-syntax-highlighting.zsh # Should be behind most other plugins
source ~/.zsh/bundle/history-substring-search/zsh-history-substring-search.zsh

# Load the rc files responsible for the rest of the initialisation.
source ~/.zsh/rc/**/*.zsh
