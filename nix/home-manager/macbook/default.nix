{ dotfiles, pkgs, pkgs-local, ... }:
{
  imports = [
    (import /${dotfiles}/nix/home-manager/gpg-agent.nix {
      inherit dotfiles;
      pinentry = pkgs-local.pinentry-auto.override {
        pinentry-gui = "${pkgs.pinentry_mac}/${pkgs.pinentry_mac.binaryPath}";
      };
    })
  ];

  home.username = "maienm";
  home.homeDirectory = "/Users/maienm";

  home.packages = with pkgs; [

    # Override the BSD version of the built-in command with GNU versions, as these are the ones I'm used to.
    coreutils-full
    findutils
    gawk
    gnugrep
    gnumake
    gnused
    gnutar

  ];

  home.file = {
    # needed for my YubiKey to work on macos, but breaks things on linux.
    ".gnupg/scdaemon.conf".text = "disable-ccid";
  };

  # Autostart synergyc.
  launchd.agents.synergy = {
    enable = true;
    config = {
      ProgramArguments = [
        "${pkgs.synergyWithoutGUI}/bin/synergyc"
        "--name"
        "MACBOOK"
        "--no-daemon"
        "localhost:24800"
      ];
      KeepAlive = true;
      ThrottleInterval = 30;
      ExitTimeOut = 0;
      RunAtLoad = true;
    };
  };

  # Setup VPNStatus for auto-reconnect.
  services.VPNStatus = {
    enable = true;
    retryDelay = 15;
    ignoredSSIDs = [ "KOEN_Wlan" ];
  };
}
