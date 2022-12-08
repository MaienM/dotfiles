# vim: et:ts=2:sw=2:sts:2

{ config, pkgs, ... }:
{
  home.username = "maienm";
  home.homeDirectory = "/home/maienm";

  home.stateVersion = "22.11";
  nixpkgs.config.allowUnfree = true;

  xsession.windowManager.command = pkgs.i3;

  services.gnome-keyring = {
    enable = true;
    components = [ "secrets" ];
  };

  home.packages = with pkgs; [

    # WM.
    dunst
    i3
    maim
    picom
    polybarFull
    redshift
    rofi
    scrot
    xorg.xkill
    yubikey-touch-detector

    # CLI.
    asdf
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
    evolution
    evolution-ews
    feh
    firefox
    google-chrome
    kitty
    mpv
    workrave

  ];
}
