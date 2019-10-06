if ! command -v kubectl &> /dev/null; then
	return
fi

_fzf_pipeline_kubernetes_base_source() {
	kubectl get "$@" -o template --template="{{range .items}}{{.metadata.selfLink}} $color_fg_yellow{{.metadata.name}}$color_reset {{range \$key, \$value := .metadata.labels}}{{\$key}}=$color_fg_cyan{{\$value}}$color_reset {{end}} $newl{{end}}" \
		| sed 's!^.*/\([^/ ]*/[^/ ]*\) !\1 !'
}
_fzf_pipeline_kubernetes_base_preview() {
	kubectl describe "$1"
}

# Create a simple pipeline and preset for each resource type
for resource in configmaps deployments endpoints namespaces nodes pods secrets services; do
	alias "_fzf_pipeline_kubernetes_${resource}_source"="_fzf_pipeline_kubernetes_base_source $resource"
	alias "_fzf_pipeline_kubernetes_${resource}_preview"='_fzf_pipeline_kubernetes_base_preview'
	alias "_fzf_preset_kubernetes_$resource"="_fzf_config_add kubernetes_$resource"
	_fzf_register_preset "kubernetes_$resource" "Kubernetes $resource" "kubernetes:$resource"
done

# Create a preset with all resource types
_fzf_preset_kubernetes() {
	echo \
		| _fzf_config_add kubernetes_pods "${color_fg_green}pod$color_reset" \
		| _fzf_config_add kubernetes_deployments "${color_fg_yellow}deployment$color_reset" \
		| _fzf_config_add kubernetes_services "${color_fg_blue}service$color_reset" \
		| _fzf_config_add kubernetes_configmaps "${color_fg_cyan}configmap$color_reset" \
		| _fzf_config_add kubernetes_endpoints "${color_fg_cyan}endpoint$color_reset" \
		| _fzf_config_add kubernetes_namespaces "${color_fg_cyan}namespace$color_reset" \
		| _fzf_config_add kubernetes_nodes "${color_fg_cyan}node$color_reset" \
		| _fzf_config_add kubernetes_secrets "${color_fg_cyan}secret$color_reset"
}
_fzf_register_preset "kubernetes" "Kubernetes (all resources)" "kubernetes:all"
