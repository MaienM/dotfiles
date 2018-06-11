# Make sure the fzf functions have been loaded
for file in ~/.zsh/rc/functions/fzf/**/*.zsh; do
    source "$file";
done

# Load the fzf pipeline files
for file in ~/.zsh/rc/fzf/**/*.zsh; do
	source "$file";
done

