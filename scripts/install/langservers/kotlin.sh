#!/usr/bin/env sh

(
	set -e

	target="$HOME/.local/share/kotlin-language-server"
	[ -d "$target" ] || git clone https://github.com/fwcd/kotlin-language-server "$target"
	cd "$target"
	./gradlew :server:installDist
)
