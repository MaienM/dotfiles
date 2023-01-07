{ pkgs, pkgs-inputs, ... }:
{
  home.stateVersion = "22.11";

  home.packages = with pkgs;
    let
      pythonPackages = python310.pkgs;
    in
    [

      # CLI.
      bat
      bc
      delta
      direnv
      exa
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
      tmux
      unzip
      xclip
      zsh

      # Applications.
      kitty
      (nerdfonts.override {
        fonts = [
          "FiraCode"
          "NerdFontsSymbolsOnly"
        ];
      })

      # Neovim.
      nodePackages.neovim
      pkgs-inputs.neovim.neovim
      pythonPackages.pynvim
      tree-sitter

      # Language servers.
      black
      efm-langserver
      nil
      nodePackages.pyright
      sumneko-lua-language-server

    ];

  home.file = {
    # Link FZF paths in a way that is compatible with the structure set up by the manual install script.
    ".vim/bundle/fzf-base".source = "${pkgs.fzf}/share/vim-plugins/fzf/";
    ".zsh/bundle/fzf/bin".source = "${pkgs.fzf}/bin/";
    ".zsh/bundle/fzf/shell".source = "${pkgs.fzf}/share/fzf/";

    # Setup gpg-agent config.
    # TODO: Once I figure out how I want to handle secrets check if that can also solve this problem.
    ".gnupg/gpg-agent.conf" = {
      text = builtins.replaceStrings
        [ "./.local/bin/pinentry-auto" ]
        [ "${../../local/bin/pinentry-auto}" ]
        (builtins.readFile ../../gnupg/gpg-agent.conf);
    };
  };
}
