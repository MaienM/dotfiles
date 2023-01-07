{ config, inputs, lib, pkgs, ... }:
{
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

  # Auto upgrade nix package and the daemon service.
  services.nix-daemon.enable = true;
  nix.package = pkgs.nix;

  # Set host.
  networking.hostName = "MICHON-MACBOOK";

  # Set locale.
  time.timeZone = "Europe/Amsterdam";

  # System packages. 
  environment.systemPackages = with pkgs; [
    home-manager
    neovim
  ];

  # Enable ZSH. This needs to happen globally since otherwise /etc/static/zshrc will not exist, and zsh will not
  # automatically source the nix environment.
  programs.zsh.enable = true;

  # Define user. This only the defines the bare minimum, as most of the user's environment is managed through home-manager.
  users.users.maienm = {
    shell = pkgs.zsh;
  };

  # Setup GPG.
  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
  };
}
