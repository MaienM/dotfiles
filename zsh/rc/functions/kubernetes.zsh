kubed() {
    kubectl describe $(fzf_run_preset "kubernetes:all")
}
