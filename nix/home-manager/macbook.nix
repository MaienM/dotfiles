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

  home.file = {
    # cached-nix-shell is not available on macos, so alias it to nix-shell.
    ".local/bin/cached-nix-shell" = {
      executable = true;
      text = ''
        #!/usr/bin/env sh
        exec "${pkgs.nix}/bin/nix-shell" "$@"
      '';
    };
  };
}
