source ~/.zsh/bundle/fzf-tab/fzf-tab.plugin.zsh
source ~/.zsh/rc/fzf.early.zsh

if [ -n "$TMUX" ] && [ "$TMUX_SUPPORT_POPUP" = 1 ]; then
	zstyle ':fzf-tab:*' fzf-command ftb-tmux-popup
fi
zstyle ':fzf-tab:*' popup-pad 50 1
zstyle ':fzf-tab:*' fzf-flags $FZF_BIND_OPTS
zstyle ':fzf-tab:complete:*:argument-rest' fzf-preview 'preview "$realpath"'
