source ~/.zsh/bundle/fzf-tab/fzf-tab.plugin.zsh
source ~/.zsh/rc/fzf.early.zsh

zstyle ':fzf-tab:*' extra-opts --preview 'preview {2}' $FZF_BIND_OPTS
