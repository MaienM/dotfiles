{ config
, dotfiles
, inputs
, lib
, pkgs
, ...
}:
let
  secrets = builtins.fromJSON (builtins.readFile ./secret.json);
in
{
  imports = [
    "${dotfiles}/nix/modules/nixos"
  ];

  # Use flakes.
  nix = {
    # This will add each flake input as a registry
    # To make nix3 commands consistent with your flake
    registry = lib.mapAttrs (_: value: { flake = value; }) inputs;

    # This will additionally add your inputs to the system's legacy channels
    # Making legacy nix commands consistent as well, awesome!
    nixPath = lib.mapAttrsToList (key: value: "${key}=${value.to.path}") config.nix.registry;

    settings = {
      # Enable flakes and new 'nix' command
      experimental-features = "nix-command flakes";
      # Deduplicate and optimize nix store
      auto-optimise-store = true;
    };
  };

  # Setup ZFS.
  boot.zfs.forceImportRoot = false;
  services.zfs = {
    autoScrub.enable = true;
    autoSnapshot = {
      enable = true;
      flags = "-k -p --utc";
    };
  };

  # Set locale.
  time.timeZone = "Europe/Amsterdam";
  i18n.defaultLocale = "en_GB.UTF-8";

  # Setup hardware firmware upgrades.
  services.fwupd.enable = true;

  # Enable nix-ld to run non-nix binaries.
  programs.nix-ld.enable = true;

  # Enable the X11 windowing system.
  services.xserver.enable = true;
  services.xserver.windowManager.i3.enable = true;
  hardware.graphics.enable = true;

  # Needed for a number of applications to manage settings.
  programs.dconf.enable = true;

  # Installed here instead of via home-manager as these need system-level workarounds.
  programs.evolution = {
    enable = true;
    plugins = with pkgs; [ evolution-ews ];
  };
  services.gnome.gnome-keyring.enable = true;
  security.pam.services.maienm.enableGnomeKeyring = true;

  # Enable sound.
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  # System-level packages. This is a pretty minimal set as a users packages are managed through home-manager.
  environment.systemPackages = with pkgs; [
    file
    git
    vim
    wget
  ];

  # Define user. This is again pretty minimal as the rest is managed through home-manager.
  programs.zsh.enable = true;
  users.users.maienm = {
    isNormalUser = true;
    hashedPassword = secrets.userPassword;
    shell = pkgs.zsh;
    extraGroups = [
      "wheel" # sudo
      "dialout" # serial devices
    ];
  };

  # Setup GPG.
  programs.gnupg.agent = {
    enable = true;
    enableExtraSocket = true;
    enableSSHSupport = true;
  };
  # Enable smartcard support, which is needed for hardware-backed GPG keys.
  services.pcscd.enable = true;

  # Setup SSH.
  services.openssh = {
    enable = true;
    settings = {
      PermitRootLogin = "no";
      PasswordAuthentication = false;
    };
  };
  users.users.maienm.openssh.authorizedKeys.keyFiles = [
    /${dotfiles}/ssh/id_rsa_gpg_28094744BA81C6A9.pub
  ];

  # Rootless containers with podman.
  virtualisation.podman = {
    enable = true;
    dockerCompat = true;
  };

  # Enable automatically mounting external storage when it is plugged in.
  services.devmon.enable = true;
  services.udisks2.enable = true;
  programs.fuse.userAllowOther = true;

  # Rootless flashing of QMK boards.
  hardware.keyboard.qmk.enable = true;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "22.11"; # Did you read the comment?
}
