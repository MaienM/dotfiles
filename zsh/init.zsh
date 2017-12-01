# Load plugins
source ~/.zsh/bundle/autosuggestions/zsh-autosuggestions.zsh
source ~/.zsh/bundle/docker-compose/docker-compose.plugin.zsh
source ~/.zsh/bundle/powerlevel9k/powerlevel9k.zsh-theme
source ~/.zsh/bundle/prezto-history/init.zsh
source ~/.zsh/bundle/syntax-highlighting/zsh-syntax-highlighting.zsh # Should be behind most other plugins
source ~/.zsh/bundle/history-substring-search/zsh-history-substring-search.zsh

# Load the rc files responsible for the rest of the initialisation.
source ~/.zsh/rc/**/*.zsh
