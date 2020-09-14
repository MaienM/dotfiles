#!/usr/bin/env bash

set -o errexit -o pipefail

echo "> Installing latest version of ${color_fg_cyan}nix-user-chroot${color_reset}."
wget 'https://github.com/nix-community/nix-user-chroot/releases/latest' -O - \
	| grep -oE '/nix-community/nix-user-chroot/releases/download/[0-9.]*/.*-x86_64-[^"]*' \
	| wget --base=http://github.com/ -i - -O ~/.local/bin/nix-user-chroot
chmod +x ~/.local/bin/nix-user-chroot

echo "> Installing latest version of ${color_fg_cyan}nix${color_reset}."
[ -d ~/.nix ] || mkdir -m 0755 ~/.nix
nix-user-chroot ~/.nix bash -c "
	export NIX_CONF_DIR=/nix/etc/nix
	export NIX_INSTALLER_NO_MODIFY_PROFILE=1
	curl -L https://nixos.org/nix/install | sh
"
