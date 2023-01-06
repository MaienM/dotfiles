alias dot-nixos-rebuild='sudo nixos-rebuild --flake "$HOME/dotfiles#$(hostname)"'
alias dot-darwin-rebuild='darwin-rebuild --flake "$HOME/dotfiles#$(hostname)"'
alias dot-home-manager='home-manager --flake "$HOME/dotfiles#${USER}@$(hostname)"'
