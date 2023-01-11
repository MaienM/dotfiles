{ pkgs, pkgs-unfree, pkgs-local, ... }:
{
  imports = [
    ./common.nix
    (import ./gpg-agent.nix {
      pinentry = pkgs-local.pinentry-auto;
    })
    ./desktop/synergy
  ];

  home.username = "maienm";
  home.homeDirectory = "/home/maienm";

  xsession = {
    enable = true;
    windowManager.command = "${pkgs.i3-gaps}/bin/i3";
  };

  services.gnome-keyring = {
    enable = true;
    components = [ "secrets" ];
  };

  home.packages = with pkgs;
    [

      # WM.
      dunst
      i3-gaps # gaps has been merged into i3, but no release has happened since
      maim
      picom
      polybarFull
      redshift
      rofi
      scrot
      xorg.xkill
      yubikey-touch-detector

      (
        python3.pkgs.buildPythonApplication rec {
          pname = "notify-send.py";
          version = "1.2.7";
          src = python3.pkgs.fetchPypi {
            inherit pname version;
            sha256 = "9olZRJ9q1mx1hGqUal6XdlZX6v5u/H1P/UqVYiw9lmM=";
          };
          propagatedBuildInputs = with python3.pkgs; [ pygobject3 dbus-python ];
        }
      )

      # CLI.
      cached-nix-shell

      # Applications.
      feh
      firefox
      mpv
      pavucontrol
      pkgs-unfree.discord
      pkgs-unfree.google-chrome
      qpwgraph
      retroarchFull
      steam-rom-manager
      workrave

    ];

  # Autostart new user systemd services.
  systemd.user.startServices = "sd-switch";
}
