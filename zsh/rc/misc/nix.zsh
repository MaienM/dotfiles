if [[ ${commands[nixos-rebuild]} ]]; then
	alias dot-nixos-rebuild='sudo nixos-rebuild --flake "$HOME/dotfiles#$(hostname)"'
fi
if [[ ${commands[darwin-rebuild]} ]]; then
	alias dot-darwin-rebuild='darwin-rebuild --flake "$HOME/dotfiles#$(hostname)"'
fi
if [[ ${commands[home-manager]} ]]; then
	alias dot-home-manager='home-manager --flake "$HOME/dotfiles#${USER}@$(hostname)"'
fi
