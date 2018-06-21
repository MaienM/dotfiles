alias docker='sudo -E docker'
alias dockc='sudo -E docker-compose'

### Viewing running containers ###

# A prettier and somewhat slimmer `docker ps` table
dockps() {
    # Format the most pertinent information
    result=$(docker ps --format='table {{.Names}}\t{{"-" | or (.Label "com.docker.compose.project")}}\t{{.Image}}\t{{.Status}}' "$@")

    # Sort by name and color the header row
    result=$(echo "$result" | (read h; echo "$COLOR_BLUE$h$COLOR_RESET"; sort))

    # Color the name group part bold yellow
    # result=$(echo "$result" | sed "s/^\(\S\+-\)/$COLOR_BOLD_GREEN\1$COLOR_RESET/")

    # Color the image repository bold green
    result=$(echo "$result" | sed "s/\(\/\S\+\)/$COLOR_BOLD_GREEN\1$COLOR_RESET/")

    # Color the image version tag green
    result=$(echo "$result" | sed "s/\(:\S\+\)/$COLOR_GREEN\1$COLOR_RESET/")

    # Color the status number bold yellow
    result=$(echo "$result" | sed "s/Up \([0-9]\+\)/Up $COLOR_BOLD_YELLOW\1$COLOR_RESET/")

    # Fix the casing for non-numeric status text
    result=$(echo "$result" | sed "s/Up \(.*\)/Up \L\1/")

    echo $result
}

# Non-running only
alias dockpss='dockps -f status=created -f status=restarting -f status=paused -f status=exited -f status=dead'

# Ordered
alias dockpsp='dockps | (read h; echo "$h"; LC_ALL=C sort -s -k2 -b)'
alias dockpsi='dockps | (read h; echo "$h"; sort -k3)'

### Logs ###

alias docklogs='docker logs --tail 30'

### Running ###

dockrunsh() {
    latest=$(docker ps -lq)
    _dockrun -d "$@"
    name=$(docker ps -lq)
    [[ -n "$name" || "$latest" == "$name" ]] || return 1
    docksh "$name"
    docker rm -f "$name"
}

# Run a docker image, with the currently directory mounted as /work
dockrun() {
    _dockrun --rm "$@"
}
_dockrun() {
    echo "Running as shell-$$"
    docker run -i --name shell-$$ -v "$PWD":/work -w /work "$@"
}

# Start a shell in a docker container
docksh() {
    name=${1:--}; shift &> /dev/null
    if [ "$name" = "-" ]; then
       name="$(docker ps -lq)"
    fi
    docker exec -it "$name" "${@:-/bin/bash}"
}

### Attaching ###

docka() {
    name=${1:-$(docker ps -lq)}; shift &> /dev/null
    docker attach --sig-proxy=false "$name"
}

### Building ###

dockbuild() {
    name="${1:-$(basename $(realpath .))}"
    basename=$(echo "$name" | sed 's/:.*//')
    autotag=$(git rev-parse HEAD 2> /dev/null || date +%Y%m%d)
    docker build -t "$basename" -t "$basename:$autotag" -t "$name" .
}

dockpush() {
    docker push ${1:-$(basename $(realpath .))}
}

dockbuildpush() {
    dockbuild "$1" && dockpush "$1"
}

### Special images/uses ###

# Expose a port as a host
# Usage: dockportashort 1234 domain
# Exploses local port 1234 as domain, assumning nginx-proxy can do that
dockportashost() {
    setopt localoptions localtraps

    # Variables
    port="$1"
    domain="$2"
    name="portashost-$domain-$port"

    if [[ -z "$1" || -z "$2" ]]; then
        echo "Usage: $0 port domain"
        return 1
    fi

    # Start the sshd server, with properties set so that nginx-proxy takes care
    # of exposing the port (in the container) as a host
    echo "Starting ssh container"
    docker run \
        -d \
        -p 8080 \
        --name="$name" \
        -e "ROOT_PASS=root" \
        -e "VIRTUAL_HOST=$domain" \
        -e "VIRTUAL_PORT=8080" \
        -e "LETSENCRYPT_HOST=$domain" \
        -e "LETSENCRYPT_EMAIL=michon1992@gmail.com" \
        georgeyord/reverse-ssh-tunnel

    # Close down the sshd server when interrupted
    trap "echo 'Removing ssh container'; docker rm -f '$name' &> /dev/null" SIGINT SIGTERM

    # SSH into the server, forwarding the local post to the container
    containerip=$(docker inspect --format '{{ .NetworkSettings.IPAddress }}' "$name")
    echo "Exposing port $port as $domain"
    sshpass -p 'root' \
        ssh -R "8080:localhost:$port" -Nf \
        -o 'StrictHostKeyChecking no' -o 'UserKnownHostsFile=/dev/null' \
        root@$containerip &> /dev/null
    echo "Done! Press ctrl+C to stop"
    sleep inf
}

### Utility ###

docker_cleanup() {
    docker rmi $(docker images -aq --filter dangling=true)
}
