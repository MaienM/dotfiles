{ config, options, inputs, lib, dotfiles, pkgs, ... }:
let
  secrets = builtins.fromJSON (builtins.readFile ./secret.json);
  bind = (path: {
    device = path;
    options = [ "bind" ];
  });
in
{
  imports = [
    ./hardware-configuration.nix
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

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Setup ZFS.
  boot.zfs.forceImportRoot = false;
  services.zfs = {
    autoScrub.enable = true;
    autoSnapshot = {
      enable = true;
      flags = "-k -p --utc";
    };
  };
  networking.hostId = "361b10a9";

  # Start with a clean root drive on every boot.
  boot.initrd.postDeviceCommands = lib.mkAfter ''
    zfs rollback -r ssd/root@blank
  '';

  # Set host.
  networking.hostName = "MICHON-PC";

  # Set locale.
  time.timeZone = "Europe/Amsterdam";
  i18n.defaultLocale = "en_GB.UTF-8";

  # Enable nix-ld to run non-nix binaries.
  programs.nix-ld.enable = true;

  # Enable the X11 windowing system.
  services.xserver.enable = true;
  services.xserver.videoDrivers = [ "nvidia" ];
  services.xserver.windowManager.i3.enable = true;
  hardware.opengl.enable = true;

  # Needed for a number of applications to manage settings.
  programs.dconf.enable = true;

  # Installed here instead of via home-manager as it needs system-level workarounds.
  programs.steam.enable = true;
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

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  custom.allowUnfreeList = [
    "cups-brother-hll2350dw"
    "nvidia-settings"
    "nvidia-x11"
    "steam"
    "steam-original"
    "steam-run"
  ];
  environment.systemPackages = with pkgs; [
    file
    home-manager
    neovim
    nerdctl
    wget
  ];

  # Define user. This only the defines the bare minimum, as most of the user's environment is managed through home-manager.
  programs.zsh.enable = true;
  users.users.maienm = {
    isNormalUser = true;
    hashedPassword = secrets.userPassword;
    shell = pkgs.zsh;
    extraGroups = [ "wheel" ];
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
    hostKeys = builtins.map
      (value: value // {
        path = builtins.replaceStrings [ "/etc/ssh/" ] [ "/persist/etc/ssh/" ] value.path;
      })
      options.services.openssh.hostKeys.default;
  };
  users.users.maienm.openssh.authorizedKeys.keyFiles = [
    /${dotfiles}/ssh/id_rsa_gpg_28094744BA81C6A9.pub
  ];

  # Enable containerd. TODO: Setup rootless?
  virtualisation.containerd.enable = true;
  fileSystems."/run/containerd" = bind "/persist/run/containerd";
  fileSystems."/var/lib/containerd" = bind "/persist/var/lib/containerd";
  fileSystems."/var/lib/nerdctl" = bind "/persist/var/lib/nerdctl";

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
