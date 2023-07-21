{ pkgs, ... }:
with pkgs; {
  cached-nix-shell = callPackage ./cached-nix-shell.nix { };
  VPNStatus = callPackage ./VPNStatus.nix { };
  nerdfonts-scripts = callPackage ./nerdfonts-scripts.nix { };
  notify-send.py = callPackage ./notify-send.py.nix { };
  pinentry-auto = callPackage ./pinentry-auto.nix { };
}
