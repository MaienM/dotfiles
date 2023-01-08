{ pkgs, pkgs-local, ... }:
{
  imports = [
    ./common.nix
    (import ./gpg-agent.nix {
      pinentry = pkgs-local.pinentry-auto.override {
        pinentry-gui = "${pkgs.pinentry_mac}/${pkgs.pinentry_mac.binaryPath}";
      };
    })
  ];

  home.username = "maienm";
  home.homeDirectory = "/Users/maienm";

  home.packages = with pkgs;
    [

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
    # cached-nix-shell is not available on macos, so alias it to nix-shell.
    ".local/bin/cached-nix-shell" = {
      executable = true;
      text = ''
        #!/usr/bin/env sh
        exec "${pkgs.nix}/bin/nix-shell" "$@"
      '';
    };

    # needed for my YubiKey to work on macos, but breaks things on linux.
    ".gnupg/scdaemon.conf".text = "disable-ccid";
  };
}
