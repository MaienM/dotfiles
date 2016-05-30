#!/bin/sh

alias docker='sudo -E docker'
alias dockps='docker ps --format="table {{.Names}}\t{{.ID}}\t{{.Image}}\t{{.Status}}\t{{.Ports}}" | less'

dockbuild() {
    name="docker.waxd.nl/${1:-$(basename $(realpath .))}"
    docker build -t "$name:$(git rev-parse HEAD)" -t "$name" .
}

dockpush() {
    docker push docker.waxd.nl/${1:-$(basename $(realpath .))}
}

dockbuildpush() {
    dockbuild "$1" && dockpush "$1"
}

docker_remove_untagged() {
    docker rmi $(docker images | grep '^<none>' | awk '{print $3}')
}
