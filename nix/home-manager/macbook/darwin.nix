{ pkgs, ... }:
{
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
}
