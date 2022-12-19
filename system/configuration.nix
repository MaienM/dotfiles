# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports =
    [
      ./hardware-configuration.nix
    ];

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Setup ZFS.
  boot.zfs.forceImportRoot = false;
  services.zfs.autoScrub.enable = true;
  networking.hostId = "361b10a9";

  # Set host.
  networking.hostName = "MICHON-PC";

  # Set locale.
  time.timeZone = "Europe/Amsterdam";
  i18n.defaultLocale = "en_GB.UTF-8";

  # Enable the X11 windowing system.
  services.xserver.enable = true;
  services.xserver.videoDrivers = [ "nvidia" ];
  services.xserver.windowManager.i3.enable = true;
  hardware.opengl.enable = true;

  # Needed for a number of applications to manage settings.
  programs.dconf.enable = true;

  # Enable sound.
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  nixpkgs.config.allowUnfree = true;
  environment.systemPackages = with pkgs; [
    file
    home-manager
    neovim
    wget
  ];

  # Define user. This only the defines the bare minimum, as most of the user's environment is managed through home-manager.
  users.users.maienm = {
    isNormalUser = true;
    shell = pkgs.zsh;
    extraGroups = [ "wheel" ];
    packages = with pkgs; [
      zsh
    ];
  };

  # Setup GPG.
  programs.gnupg.agent = {
    enable = true;
    enableExtraSocket = true;
    enableSSHSupport = true;
  };
  services.pcscd.enable = true; # Needed for hardware-backed GPG keys.

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "22.11"; # Did you read the comment?
}
