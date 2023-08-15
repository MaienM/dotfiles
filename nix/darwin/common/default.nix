{ dotfiles , ... }:
{
  imports = [
    "${dotfiles}/nix/modules/darwin"
  ];
}
