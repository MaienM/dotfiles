{ pkgs, pkgs-unfree, pkgs-local, ... }:
{
  imports = [
    ./common.nix
    (import ./gpg-agent.nix {
      pinentry = pkgs-local.pinentry-auto;
    })
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
    let
      pythonPackages = python310.pkgs;
    in
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
        pythonPackages.buildPythonApplication rec {
          pname = "notify-send.py";
          version = "1.2.7";
          src = pythonPackages.fetchPypi {
            inherit pname version;
            sha256 = "9olZRJ9q1mx1hGqUal6XdlZX6v5u/H1P/UqVYiw9lmM=";
          };
          propagatedBuildInputs = with pythonPackages; [ pygobject3 dbus-python ];
        }
      )

      # CLI.
      cached-nix-shell

      # Applications.
      feh
      firefox
      mpv
      pkgs-unfree.discord
      pkgs-unfree.google-chrome
      retroarchFull
      steam-rom-manager
      workrave

    ];
}
