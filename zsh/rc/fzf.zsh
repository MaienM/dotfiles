# Make sure the fzf functions have been loaded
for file in ~/.zsh/rc/functions/fzf/**/*.zsh; do
    source "$file";
done

# Load the fzf pipeline files
for file in ~/.zsh/rc/fzf/**/*.zsh; do
	source "$file";
done

# Change the multi-select direction, so you can just repeatedly hit tab to select everything
export FZF_DEFAULT_OPTS="--bind tab:toggle-out,shift-tab:toggle-in"
