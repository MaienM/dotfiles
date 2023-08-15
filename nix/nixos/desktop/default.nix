{ lib, pkgs, ... }:
{
  imports = [
    ./hardware-configuration.nix
    ./persist.nix
  ];

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Start with a clean root drive on every boot.
  boot.initrd.postDeviceCommands = lib.mkAfter ''
    zfs rollback -r ssd/root@blank
  '';

  # Set host.
  networking.hostName = "MICHON-PC";
  networking.hostId = "361b10a9";

  # Unfree packages.
  custom.allowUnfreeList = [
    # Printer drivers.
    "cups-brother-hll2350dw"
    # Nvidia drivers.
    "nvidia-settings"
    "nvidia-x11"
    # Steam (installed via home-manager).
    "steam"
    "steam-original"
    "steam-run"
  ];

  # Use Nvidia drivers.
  services.xserver.videoDrivers = [ "nvidia" ];

  # Installed here instead of via home-manager as these need system-level workarounds.
  programs.steam.enable = true;

  # System-level packages.
  environment.systemPackages = with pkgs; [
    # Needed for steam to be able to show a file picker (e.g. add non steam game -> browse).
    xdg-desktop-portal
    xdg-desktop-portal-kde
  ];

  # Enable binfmt emulation for aarch64-linux, to cross-compile for RPI.
  boot.binfmt.emulatedSystems = [ "aarch64-linux" ];

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "22.11"; # Did you read the comment?
}
