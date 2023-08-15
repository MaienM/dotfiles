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
    minigalaxy
    qpwgraph

  ];
}
