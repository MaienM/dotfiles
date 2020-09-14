#!/usr/bin/env sh

set -e

nix-shell "
	nix-env -iA cachix -f https://cachix.org/api/v1/install
	cachix use srid
	nix-env -if https://github.com/srid/neuron/archive/master.tar.gz
"
