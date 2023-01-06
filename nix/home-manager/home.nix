{ config, pkgs, pkgs-unfree, pkgs-inputs, ... }:
{
  home.username = "maienm";
  home.homeDirectory = "/home/maienm";

  home.stateVersion = "22.11";

  xsession = {
    enable = true;
    windowManager.command = "${pkgs.i3-gaps}/bin/i3";
  };

  services.gnome-keyring = {
    enable = true;
    components = [ "secrets" ];
  };

  home.packages = with pkgs;
    let
      pythonPackages = python310.pkgs;
    in
    [

      # WM.
      dunst
      i3-gaps # gaps has been merged into i3, but no release has happened since
      maim
      picom
      polybarFull
      redshift
      rofi
      scrot
      xorg.xkill
      yubikey-touch-detector

      (
        pythonPackages.buildPythonApplication rec {
          pname = "notify-send.py";
          version = "1.2.7";
          src = pythonPackages.fetchPypi {
            inherit pname version;
            sha256 = "9olZRJ9q1mx1hGqUal6XdlZX6v5u/H1P/UqVYiw9lmM=";
          };
          propagatedBuildInputs = with pythonPackages; [ pygobject3 dbus-python ];
        }
      )

      # CLI.
      bat
      bc
      cached-nix-shell
      delta
      direnv
      exa
      fontforge
      fzf
      git
      git-lfs
      gnupg
      htop
      jq
      mimeo
      nixpkgs-fmt
      nodejs
      p7zip
      python3
      ripgrep
      socat
      sqlite
      subversion
      tmux
      unzip
      xclip
      zsh

      # Applications.
      feh
      firefox
      kitty
      mpv
      pkgs-unfree.discord
      pkgs-unfree.google-chrome
      retroarchFull
      steam-rom-manager
      workrave

      # Neovim
      nodePackages.neovim
      pkgs-inputs.neovim.neovim
      pythonPackages.pynvim
      tree-sitter

      # Language servers
      nil
      sumneko-lua-language-server
      nodePackages.pyright

    ];

  home.file = {
    # Path needed for steam-rom-manager.
    ".local/links/retroarch".source = pkgs.retroarchFull;
  };
}
