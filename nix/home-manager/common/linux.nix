{
  pkgs,
  pkgs-force,
  pkgs-local,
  ...
}:
{
  xsession = {
    enable = true;
    windowManager.command = "${pkgs.i3}/bin/i3";
  };

  custom.allowUnfreeList = [
    "discord"
  ];
  home.packages = with pkgs; [

    # WM.
    dunst
    i3
    maim
    picom
    pkgs-local.notify-send.py
    polybarFull
    redshift
    rofi
    scrot
    xorg.xkill
    yubikey-touch-detector

    # Applications.
    chromium
    feh
    firefoxpwa
    mpv
    pavucontrol
    pkgs-force.discord # Marked incompatible with aarch64-linux.
    workrave

  ];

  programs.firefox = {
    enable = true;
    nativeMessagingHosts = with pkgs; [
      firefoxpwa
    ];
  };
}
