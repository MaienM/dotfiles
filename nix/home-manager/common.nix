{ pkgs, pkgs-inputs, pkgs-local, ... }:
{
  home.stateVersion = "22.11";

  home.packages = with pkgs;
    [

      # CLI.
      bat
      bc
      delta
      direnv
      exa
      fzf
      git
      git-crypt
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
      tmux
      unzip
      vifm-full
      xclip
      zsh

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
      gcc # Needed for treesitter to compile parsers.
      nodePackages.neovim
      pkgs-inputs.neovim.neovim
      python3.pkgs.pynvim
      tree-sitter

      # Language servers.
      black
      efm-langserver
      nil
      nodePackages.pyright
      rust-analyzer
      sumneko-lua-language-server

    ];

  home.file = {
    # Link FZF paths in a way that is compatible with the structure set up by the manual install script.
    ".vim/bundle/fzf-base".source = "${pkgs.fzf}/share/vim-plugins/fzf/";
    ".zsh/bundle/fzf/bin".source = "${pkgs.fzf}/bin/";
    ".zsh/bundle/fzf/shell".source = "${pkgs.fzf}/share/fzf/";
  };
}
