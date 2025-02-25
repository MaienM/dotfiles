{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    flake-utils.url = "github:numtide/flake-utils";

    darwin.url = "github:lnl7/nix-darwin/master";
    darwin.inputs.nixpkgs.follows = "nixpkgs";

    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    apple-silicon.url = "github:tpwrules/nixos-apple-silicon";

    neovim.url = "github:nix-community/neovim-nightly-overlay";
    neovim.inputs.nixpkgs.follows = "nixpkgs";

    drduh.url = "github:drduh/YubiKey-Guide";
    drduh.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs =
    {
      nixpkgs,
      flake-utils,
      darwin,
      home-manager,
      ...
    }@inputs:
    flake-utils.lib.eachDefaultSystem (
      system:
      let
        dotfiles = ./.;
        pkgs = nixpkgs.legacyPackages.${system};
        pkgs-force = import "${nixpkgs}" {
          inherit system;
          config = {
            allowBroken = true;
            allowUnfree = true;
            allowUnsupportedSystem = true;
          };
        };
        pkgs-inputs = # { name = inputs.${name}.packages.${system} }
          builtins.mapAttrs (
            _:
            nixpkgs.lib.attrByPath [
              "packages"
              system
            ] { }
          ) inputs;
        pkgs-local = import ./nix/pkgs {
          inherit
            inputs
            system
            pkgs
            pkgs-inputs
            pkgs-local
            ;
        };

        dot-nixos-rebuild = pkgs.writeShellApplication {
          name = "dot-nixos-rebuild";
          runtimeInputs = [ pkgs.nixos-rebuild ];
          text = ''
            sudo nixos-rebuild --flake "$HOME/dotfiles#''${HOSTNAME:-$(hostname)}" "$@"
          '';
        };
        dot-channel-sync = pkgs.writeShellApplication {
          name = "dot-channel-sync";
          runtimeInputs = [ pkgs.nix ];
          text = ''
            nix-channel --add https://github.com/NixOS/nixpkgs/archive/${inputs.nixpkgs.rev}.tar.gz nixpkgs
            nix-channel --update nixpkgs
          '';
        };
        dot-darwin-rebuild =
          if pkgs-inputs.darwin ? "darwin-rebuild" && pkgs-inputs.darwin.darwin-rebuild.meta.available then
            pkgs.writeShellApplication {
              name = "dot-darwin-rebuild";
              runtimeInputs = [ pkgs-inputs.darwin.darwin-rebuild ];
              text = ''
                darwin-rebuild --flake "$HOME/dotfiles#''${HOSTNAME:-$(hostname)}" "$@"
              '';
            }
          else
            pkgs.empty;
        dot-home-manager = pkgs.writeShellApplication {
          name = "dot-home-manager";
          runtimeInputs = [ pkgs-inputs.home-manager.home-manager ];
          text = ''
            home-manager --flake "$HOME/dotfiles#$USER@''${HOSTNAME:-$(hostname)}" "$@"
          '';
        };

        specialArgs = {
          inherit
            inputs
            dotfiles
            system
            pkgs-force
            pkgs-inputs
            pkgs-local
            ;
          inherit (pkgs) stdenv;
        };
      in
      {
        packages = pkgs-local // {
          inherit (pkgs) nixos-rebuild;
          inherit (pkgs-inputs.darwin) darwin-rebuild;
          inherit (pkgs-inputs.home-manager) home-manager;
          inherit
            dot-nixos-rebuild
            dot-channel-sync
            dot-darwin-rebuild
            dot-home-manager
            ;

          nixosConfigurations = {
            MICHON-PC = nixpkgs.lib.nixosSystem {
              inherit specialArgs;
              modules = [
                ./nix/nixos/common
                ./nix/nixos/desktop
              ];
            };
            MICHON-MACBOOK = nixpkgs.lib.nixosSystem {
              inherit specialArgs;
              modules = [
                ./nix/nixos/common
                ./nix/nixos/macbook
              ];
            };
            YUBIKEY = inputs.drduh.nixosConfigurations.yubikeyLive.${system}.extendModules {
              modules = [
                {
                  environment.systemPackages = with pkgs; [
                    neovim
                    pinentry-curses
                  ];
                }
              ];
            };
          };

          darwinConfigurations = {
            MICHON-MACBOOK = darwin.lib.darwinSystem {
              inherit specialArgs system;
              modules = [
                ./nix/darwin/common
                ./nix/darwin/macbook
              ];
            };
          };

          homeConfigurations = {
            "maienm@MICHON-PC" = home-manager.lib.homeManagerConfiguration {
              inherit pkgs;
              extraSpecialArgs = specialArgs;
              modules = [
                ./nix/home-manager/common
                ./nix/home-manager/desktop
              ];
            };
            "maienm@MICHON-MACBOOK" = home-manager.lib.homeManagerConfiguration {
              inherit pkgs;
              extraSpecialArgs = specialArgs;
              modules = [
                ./nix/home-manager/common
                ./nix/home-manager/macbook
              ];
            };
            "maienm@neptune" = home-manager.lib.homeManagerConfiguration {
              inherit pkgs;
              extraSpecialArgs = specialArgs;
              modules = [
                ./nix/home-manager/common
                ./nix/home-manager/neptune.nix
              ];
            };
          };
        };

        devShell = pkgs.mkShell {
          buildInputs = with pkgs; [
            dot-nixos-rebuild
            dot-channel-sync
            dot-darwin-rebuild
            dot-home-manager

            python3
            python3.pkgs.pytest
          ];
        };
      }
    );
}
