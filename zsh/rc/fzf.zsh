# Make sure the fzf functions have been loaded
for file in ~/.zsh/rc/fzf/functions/**/*.zsh; do
	source "$file";
done

# Load the fzf pipeline files
for file in ~/.zsh/rc/fzf/**/*.zsh; do
	source "$file";
done

# Add a preview to the built-in ctrl-t keybinding
export FZF_CTRL_T_OPTS="$FZF_CTRL_T_OPTS --preview 'preview {}'"
export FZF_ALT_C_OPTS="$FZF_ALT_C_OPTS --preview 'preview {}'"

# Load the base16 theme
export FZF_DEFAULT_OPTS=""
[ -f $HOME/.base16_theme_fzf ] && source $HOME/.base16_theme_fzf
# Remove the background color, to make transparency work
export FZF_DEFAULT_OPTS="$FZF_DEFAULT_OPTS --color=bg+:-1,bg:-1"
# Change the multi-select direction, so you can just repeatedly hit tab to select everything
export FZF_DEFAULT_OPTS="$FZF_DEFAULT_OPTS --bind tab:toggle-out,shift-tab:toggle-in"
# Allow moving around with hjkl, using h and l for pages
export FZF_DEFAULT_OPTS="$FZF_DEFAULT_OPTS --bind ctrl-h:page-up,ctrl-l:page-down"
export FZF_DEFAULT_OPTS="$FZF_DEFAULT_OPTS --bind alt-j:preview-down,alt-k:preview-up"
export FZF_DEFAULT_OPTS="$FZF_DEFAULT_OPTS --bind alt-h:preview-page-up,alt-l:preview-page-down"
