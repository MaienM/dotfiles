{ dotfiles, pkgs, pkgs-local, ... }:
{
  imports = [
    (import /${dotfiles}/nix/home-manager/gpg-agent.nix {
      inherit dotfiles;
      pinentry = pkgs-local.pinentry-auto;
    })
    ./synergy
  ];

  home.username = "maienm";
  home.homeDirectory = "/home/maienm";

  xsession = {
    enable = true;
    windowManager.command = "${pkgs.i3-gaps}/bin/i3";
  };

  custom.allowUnfreeList = [
    "discord"
    "google-chrome"
    "steam-original"
    "steam-run"
  ];
  home.packages = with pkgs;
    [

      # WM.
      dunst
      i3-gaps # gaps has been merged into i3, but no release has happened since
      maim
      picom
      pkgs-local.notify-send.py
      polybarFull
      redshift
      rofi
      scrot
      xorg.xkill
      yubikey-touch-detector

      # CLI.
      cached-nix-shell

      # Applications.
      discord
      feh
      firefox
      google-chrome
      minigalaxy
      mpv
      pavucontrol
      qpwgraph
      workrave

    ];

  # Autostart new user systemd services.
  systemd.user.startServices = "sd-switch";
}
