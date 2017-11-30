# Load silzsh.
# This has to happen before anything else, so we can be sure that all plugins
# and such are available for use in the zshrc files.
source ~/.zsh/bundle/zilsh/zilsh.zsh
zilsh_init ~/.zsh/bundle

# Load the rc files responsible for the rest of the initialisation.
source ~/.zsh/rc/**/*.zsh
