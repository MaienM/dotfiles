{ pkgs, ... }:
{
  imports = [
    ./synergy
  ];

  custom.allowUnfreeList = [
    "steam-original"
    "steam-run"
  ];
  home.packages = with pkgs; [

    # Applications.
    bambu-studio
    minigalaxy
    prismlauncher
    qpwgraph

  ];
}
