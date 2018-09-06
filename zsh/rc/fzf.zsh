# Make sure the fzf functions have been loaded
for file in ~/.zsh/rc/fzf/functions/**/*.zsh; do
	source "$file";
done

# Load the fzf pipeline files
for file in ~/.zsh/rc/fzf/**/*.zsh; do
	source "$file";
done

# Load the base16 theme
export FZF_DEFAULT_OPTS=""
[ -f $HOME/.base16_theme_fzf ] && source $HOME/.base16_theme_fzf
# Remove the background color, to make transparency work
export FZF_DEFAULT_OPTS="$FZF_DEFAULT_OPTS --color=bg+:-1,bg:-1"
# Change the multi-select direction, so you can just repeatedly hit tab to select everything
export FZF_DEFAULT_OPTS="$FZF_DEFAULT_OPTS --bind tab:toggle-out,shift-tab:toggle-in"
