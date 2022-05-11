source ~/.zsh/bundle/fzf-tab/fzf-tab.plugin.zsh
source ~/.zsh/rc/fzf.early.zsh

# Use tmux popup if available.
if [ -n "$TMUX" ] && [ "$TMUX_SUPPORT_POPUP" = 1 ]; then
	zstyle ':fzf-tab:*' fzf-command ftb-tmux-popup
fi

# Minimal size.
zstyle ':fzf-tab:*' popup-pad 50 1

# Add my default keybinds.
zstyle ':fzf-tab:*' fzf-flags $FZF_BIND_OPTS

# Completions.
zstyle ':fzf-tab:complete:pacman:*' fzf-preview 'pacman -Si "$word"'
zstyle ':fzf-tab:complete:pacman:*' popup-pad 100 1

# Use preview as preview command for arguments where it's plausible these are files, unless something better is defined.
zstyle ':fzf-tab:complete:*:argument-rest' fzf-preview 'preview "$realpath"'
