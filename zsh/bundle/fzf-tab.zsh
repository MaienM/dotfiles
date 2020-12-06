source ~/.zsh/bundle/fzf-tab/fzf-tab.plugin.zsh
source ~/.zsh/rc/fzf.early.zsh

zstyle ':fzf-tab:*' fzf-flags $FZF_BIND_OPTS
zstyle ':fzf-tab:complete:*:argument-rest' fzf-preview 'preview "$realpath"'
