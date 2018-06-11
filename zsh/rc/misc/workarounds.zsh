# Workaround for issue https://github.com/docker/compose/issues/3633
# Set the timeout to a year. This will probably be annoying for some cases, but it prevents timeouts when nothing is wrong
export COMPOSE_HTTP_TIMEOUT=$((60 * 60 * 24 * 365))
