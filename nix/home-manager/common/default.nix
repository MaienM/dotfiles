{ config
, dotfiles
, lib
, pkgs
, pkgs-inputs
, pkgs-local
, stdenv
, ...
}:
{
  imports = [
    "${dotfiles}/nix/modules/home-manager"
    (if stdenv.isDarwin then ./darwin.nix else ./linux.nix)
  ];

  home.stateVersion = "22.11";

  home.username = lib.mkDefault "maienm";
  home.homeDirectory = lib.mkDefault "/${if stdenv.isDarwin then "/Users" else "home"}/${config.home.username}";

  home.packages = with pkgs; [

    # CLI.
    bat
    bc
    delta
    direnv
    eza
    fzf
    git
    git-crypt
    git-lfs
    gnupg
    htop
    jq
    mimeo
    moreutils
    nixpkgs-fmt
    nodejs
    p7zip
    pkgs-local.cached-nix-shell
    python3
    ripgrep
    socat
    sqlite
    tmux
    unzip
    vifm
    xclip
    yamlfmt
    yq
    zsh

    (writeShellApplication {
      name = "xdg-open";
      runtimeInputs = [ mimeo ];
      text = ''exec mimeo "$@"'';
    })

    # Applications.
    kitty
    pkgs-local.nerdfonts-scripts

    (nerdfonts.override {
      fonts = [
        "FiraCode"
        "NerdFontsSymbolsOnly"
      ];
    })

    # Neovim.
    (if pkgs.system == "aarch64-darwin" then pkgs-inputs.neovim-darwin else pkgs-inputs.neovim).neovim
    gcc # Needed for treesitter to compile parsers.
    nodePackages.neovim
    python3.pkgs.pynvim
    tree-sitter

    # Language servers/tools.
    autoflake
    black
    deadnix
    editorconfig-checker
    isort
    lua-language-server
    nil
    nodePackages.pyright
    rust-analyzer
    shellcheck
    shfmt
    statix
    stylua
    zk

  ];

  # Make added fonts available with fontconfig.
  fonts.fontconfig.enable = true;

  home.file = {
    # Link FZF paths in a way that is compatible with the structure set up by the manual install script.
    ".vim/bundle/fzf-base".source = "${pkgs.fzf}/share/vim-plugins/fzf/";
    ".zsh/bundle/fzf/bin".source = "${pkgs.fzf}/bin/";
    ".zsh/bundle/fzf/shell".source = "${pkgs.fzf}/share/fzf/";

    # Setup gpg-agent config.
    # TODO: Once I figure out how I want to handle secrets check if that can also solve this problem.
    ".gnupg/gpg-agent.conf" = {
      text = builtins.replaceStrings
        [ "pinentry-auto" ]
        [ "${config.home.homeDirectory}/.nix-profile/bin/pinentry-auto" ]
        (builtins.readFile /${dotfiles}/gnupg/gpg-agent.conf);
    };

    # Make mpv use yt-dlp.
    ".config/mpv/youtube-dl".source = "${pkgs-local.yt-dlp}/bin/yt-dlp";
  };

  # Autostart new user systemd services.
  systemd.user.startServices = "sd-switch";
}
