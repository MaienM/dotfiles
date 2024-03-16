{ pkgs, ... }:
with pkgs; {
  VPNStatus = callPackage ./VPNStatus.nix { };
  cached-nix-shell = callPackage ./cached-nix-shell.nix { };
  nerdfonts-scripts = callPackage ./nerdfonts-scripts.nix { };
  notify-send.py = callPackage ./notify-send.py.nix { };
  yt-dlp = callPackage ./yt-dlp.nix { };
}
