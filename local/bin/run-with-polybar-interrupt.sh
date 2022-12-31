#!/usr/bin/env bash

# shellcheck source=./wrapper.sh
. ~/.local/bin/wrapper.sh

set -e

trap "$HOME/.config/polybar/scripts/send-interrupt.sh $(basename "$0")" EXIT

"$ORIG_BIN" "$@"
