# vim: et:ts=2:sw=2:sts=2

{ config, pkgs, ... }:
{
  home.username = "maienm";
  home.homeDirectory = "/home/maienm";

  home.stateVersion = "22.11";
  nixpkgs.config.allowUnfree = true;

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
      bat
      bc
      delta
      exa
      fontforge
      git
      gnupg
      jq
      mimeo
      nixpkgs-fmt
      nodejs
      python3
      ripgrep
      socat
      sqlite
      subversion
      tmux
      unzip
      xclip
      zsh

      # Applications.
      discord
      feh
      firefox
      google-chrome
      kitty
      mpv
      workrave

      # Neovim
      pythonPackages.pynvim
      nodePackages.neovim

  ];
}
