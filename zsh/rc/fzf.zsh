# Make sure the fzf functions have been loaded
for file in ~/.zsh/rc/fzf/functions/**/*.zsh; do
	source "$file";
done

# Load the fzf pipeline files
for file in ~/.zsh/rc/fzf/**/*.zsh; do
	source "$file";
done

# Add a preview to the built-in ctrl-t keybinding
[[ "$FZF_CTRL_T_OPTS" = *'--preview'* ]] || export FZF_CTRL_T_OPTS="$FZF_CTRL_T_OPTS --preview 'preview {}'"
[[ "$FZF_ALT_C_OPTS" = *'--preview'* ]] || export FZF_ALT_C_OPTS="$FZF_ALT_C_OPTS --preview 'preview {}'"

# Load the base16 theme
export FZF_DEFAULT_OPTS=""
[ -f "$HOME/.base16_theme_fzf" ] && source "$HOME/.base16_theme_fzf"
# Remove the background color, to make transparency work
export FZF_DEFAULT_OPTS="$FZF_DEFAULT_OPTS --color=bg+:-1,bg:-1"
# Add keybindings
export FZF_DEFAULT_OPTS="$FZF_DEFAULT_OPTS $FZF_BIND_OPTS"
