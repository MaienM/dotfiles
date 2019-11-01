alias kubed='kubectl describe'

# A nice interactive inspector for the general state of things.
kubei() {
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

# Event listing for the given element in the form of type/name.
kubee() {
	kind="${1%/*}"
	kind="$(tr '[:lower:]' '[:upper:]' <<< "${kind:0:1}")${kind:1}"
	kind="${kind%s}"
	name="${1#*/}"
	kubectl get events --all-namespaces --field-selector "involvedObject.kind=$kind,involvedObject.name=$name"
}

