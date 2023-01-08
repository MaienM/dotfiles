{ pkgs, ... }:
with pkgs; {
  pinentry-auto = callPackage ./pinentry-auto.nix { };
}
