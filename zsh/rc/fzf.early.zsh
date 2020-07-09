# FZF options to setup keybindings
export FZF_BIND_OPTS=(
	# Change the multi-select direction, so you can just repeatedly hit tab to select everything
	--bind 'tab:toggle-out,shift-tab:toggle-in'
	# Allow moving around with hjkl, using h and l for pages
	--bind 'ctrl-h:page-up,ctrl-l:page-down'
	# Allow moving the preview with the same keys using alt instead of control
	--bind 'alt-j:preview-down,alt-k:preview-up'
	--bind 'alt-h:preview-page-up,alt-l:preview-page-down'
)
