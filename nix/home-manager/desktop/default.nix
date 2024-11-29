{ pkgs, ... }:
{
  imports = [
    ./synergy
  ];

  custom.allowUnfreeList = [
    "steam-original"
    "steam-run"
    "steam-unwrapped"
  ];

  home.packages = with pkgs; [

    # Applications.
    bambu-studio
    minigalaxy
    prismlauncher
    qpwgraph

  ];
}
