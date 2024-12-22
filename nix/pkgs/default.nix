{ pkgs, ... }:
with pkgs;
{
  VPNStatus = callPackage ./VPNStatus.nix { };
  cached-nix-shell = callPackage ./cached-nix-shell.nix { };
  leveldb-cli = callPackage ./leveldb-cli.nix { };
  nerdfonts-scripts = callPackage ./nerdfonts-scripts.nix { };
  notify-send.py = callPackage ./notify-send.py.nix { };
  yt-dlp = callPackage ./yt-dlp.nix { };
}
