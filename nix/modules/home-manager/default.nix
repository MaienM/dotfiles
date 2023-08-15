{ dotfiles, ... }:
{
  imports = [
    "${dotfiles}/nix/modules/common"
    ./VPNStatus.nix
    ./pinentry-auto.nix
  ];
}
