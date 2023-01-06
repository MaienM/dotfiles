#!/usr/bin/env sh

SSH_AUTH_SOCK="$(gpgconf --list-dirs agent-ssh-socket)"
export SSH_AUTH_SOCK

export GPG_TTY=$TTY
export PINENTRY_USER_DATA=TTY=$TTY
