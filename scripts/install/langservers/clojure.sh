#!/usr/bin/env sh

set -e

tmpdir="$(mktemp -d)"
wget 'https://github.com/clojure-lsp/clojure-lsp/releases/latest' -O - \
	| grep -oE '/clojure-lsp/clojure-lsp/releases/download/[0-9.\-]*/clojure-lsp-native-linux-amd64.zip' \
	| wget --base=http://github.com/ -i - -O "$tmpdir/clojure-lsp.zip"
unzip "$tmpdir/clojure-lsp.zip" -d "$tmpdir"
chmod +x "$tmpdir/clojure-lsp"
mv "$tmpdir/clojure-lsp" "$HOME/.local/bin/"
