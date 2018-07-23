_fzf_require_sudo() {
    # When in preview, just fail silently
    if [ -n "$FZF_PREVIEW_HEIGHT" ]; then
        echo "This pipeline requires sudo and is not suitable for preview" >&2
        exit 1;
    fi

    # Prompt for sudo
    sudo "$@"
}

# Containers
_fzf_pipeline_docker_containers_source() {
    _fzf_require_sudo docker ps --format="{{.ID}} ${fg[yellow]}{{.Names}}$reset_color{{if (.Label \"com.docker.compose.project\")}} (part of ${fg[blue]}{{.Label \"com.docker.compose.project\"}}$reset_color){{end}} is an instance of ${fg[cyan]}{{.Image}}$reset_color"
}
_fzf_pipeline_docker_containers_preview() {
    docker-tools inspect $1
}

# Presets
alias _fzf_preset_docker_containers='_fzf_config_add docker_containers'

_fzf_register_preset "docker_containers" "Docker containers" "docker:containers"
