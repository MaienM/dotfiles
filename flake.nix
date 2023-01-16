{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-22.11";

    flake-utils.url = "github:numtide/flake-utils";

    darwin.url = "github:lnl7/nix-darwin/master";
    darwin.inputs.nixpkgs.follows = "nixpkgs";

    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    neovim.url = "github:neovim/neovim?dir=contrib";
    neovim.inputs.nixpkgs.follows = "nixpkgs";
    neovim.inputs.flake-utils.follows = "flake-utils";
  };

  outputs = { nixpkgs, flake-utils, darwin, home-manager, ... }@inputs: flake-utils.lib.eachDefaultSystem (system:
    let
      dotfiles = ./.;
      pkgs = nixpkgs.legacyPackages.${system};
      pkgs-unfree = import "${nixpkgs}" {
        inherit system;
        config.allowUnfree = true;
      };
      pkgs-inputs = # { name = inputs.${name}.packages.${system} }
        builtins.mapAttrs
          (_: nixpkgs.lib.attrByPath [ "packages" system ] { })
          inputs;
      pkgs-local = import ./nix/pkgs {
        inherit inputs system pkgs;
      };
    in
    {
      packages = {
        # dot-nixos-rebuild (which is an alias for nixos-rebuild --flake .#your-hostname).
        nixosConfigurations = {
          MICHON-PC = nixpkgs.lib.nixosSystem {
            specialArgs = {
              inherit inputs dotfiles pkgs-unfree pkgs-inputs pkgs-local;
            };
            modules = [
              ./nix/modules/nixos
              ./nix/nixos/desktop
            ];
          };
        };

        # dot-darwin-rebuild (which is an alias for darwin-rebuild --flake .#your-hostname).
        darwinConfigurations = {
          MICHON-MACBOOK = darwin.lib.darwinSystem {
            specialArgs = {
              inherit inputs dotfiles pkgs-unfree pkgs-inputs pkgs-local;
            };
            system = "aarch64-darwin";
            modules = [
              ./nix/modules/darwin
              ./nix/darwin/macbook
            ];
          };
        };

        # dot-home-manager (which is an alias for home-manager --flake .#your-username@your-hostname).
        homeConfigurations = {
          "maienm@MICHON-PC" = home-manager.lib.homeManagerConfiguration {
            inherit pkgs;
            extraSpecialArgs = {
              inherit inputs dotfiles pkgs-unfree pkgs-inputs pkgs-local;
            };
            modules = [
              ./nix/modules/home-manager
              ./nix/home-manager/common.nix
              ./nix/home-manager/desktop
            ];
          };
          "maienm@MICHON-MACBOOK" = home-manager.lib.homeManagerConfiguration {
            inherit pkgs;
            extraSpecialArgs = {
              inherit inputs dotfiles pkgs-unfree pkgs-inputs pkgs-local;
            };
            modules = [
              ./nix/modules/home-manager
              ./nix/home-manager/common.nix
              ./nix/home-manager/macbook
            ];
          };
        };
      };
    }
  );
}
