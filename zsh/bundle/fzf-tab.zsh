source ~/.zsh/bundle/fzf-tab/fzf-tab.plugin.zsh
source ~/.zsh/rc/fzf.early.zsh

zstyle ':fzf-tab:*' extra-opts $FZF_BIND_OPTS
zstyle ':fzf-tab:complete:*:argument-rest' extra-opts $FZF_BIND_OPTS --preview 'preview {2}'
