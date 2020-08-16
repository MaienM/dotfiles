source ~/.zsh/bundle/fzf-tab/fzf-tab.plugin.zsh
source ~/.zsh/rc/fzf.early.zsh

# Helper snippet from the fzf-tab readme to get the full path of the entry that is being previewed.
local extract="
	local in=\${\${\"\$(<{f})\"%\$'\0'*}#*\$'\0'}
	local -A ctxt=(\"\${(@ps:\2:)CTXT}\")
	local realpath=\${ctxt[IPREFIX]}\${ctxt[hpre]}\$in
	realpath=\${(Qe)~realpath}
"

zstyle ':fzf-tab:*' extra-opts $FZF_BIND_OPTS
zstyle ':fzf-tab:complete:*:argument-rest' extra-opts $FZF_BIND_OPTS --preview "$extract; "'preview "$realpath"'
