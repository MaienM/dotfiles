{ pkgs, ... }:
with pkgs; {
  VPNStatus = callPackage ./VPNStatus.nix { };
  nerdfonts-scripts = callPackage ./nerdfonts-scripts.nix { };
  notify-send.py = callPackage ./notify-send.py.nix { };
  pinentry-auto = callPackage ./pinentry-auto.nix { };
}
