kubed() {
	local cmd
	cmd=($(fzf_run_preset "kubernetes:all" \
		--header=$'Usage:\nAlt + d: describe\nAlt + l: logs (+ Ctrl for follow)' \
		--bind="enter:abort" \
		--bind="alt-d:abort+execute(echo kubectl describe {2} >&4)" \
		--bind="alt-l:abort+execute(echo kubectl logs {2} >&4)" \
		--bind="ctrl-alt-l:abort+execute(echo kubectl logs -f {2} >&4)" \
	4>&1))
	if [[ -n "${cmd[@]}" ]]; then
		history_add_and_run ${cmd[@]}
	fi
}
