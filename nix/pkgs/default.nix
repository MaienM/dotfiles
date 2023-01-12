{ pkgs, ... }:
with pkgs; {
  notify-send.py = callPackage ./notify-send.py.nix { };
  pinentry-auto = callPackage ./pinentry-auto.nix { };
  VPNStatus = callPackage ./VPNStatus.nix { };
}
