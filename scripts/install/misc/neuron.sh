#!/usr/bin/env sh

set -e

cd "$(mktemp -d)"
wget 'https://github.com/srid/neuron/releases/latest' -O - \
	| grep -oE '/srid/neuron/releases/download/[0-9.]*/.*-linux\.tar\.gz' \
	| wget --base=http://github.com/ -i - -O archive.tar.gz
tar -xzf archive.tar.gz
chmod +x ./neuron
mv ./neuron ~/.local/bin/
