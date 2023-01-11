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
  };

  outputs = { nixpkgs, flake-utils, darwin, home-manager, ... }@inputs: flake-utils.lib.eachDefaultSystem (system:
    let
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
            specialArgs = { inherit inputs; };
            modules = [ ./nix/nixos/configuration.nix ];
          };
        };

        # dot-darwin-rebuild (which is an alias for darwin-rebuild --flake .#your-hostname).
        darwinConfigurations = {
          MICHON-MACBOOK = darwin.lib.darwinSystem {
            inherit inputs;
            system = "aarch64-darwin";
            modules = [ ./nix/darwin/configuration.nix ];
          };
        };

        # dot-home-manager (which is an alias for home-manager --flake .#your-username@your-hostname).
        homeConfigurations = {
          "maienm@MICHON-PC" = home-manager.lib.homeManagerConfiguration {
            inherit pkgs;
            extraSpecialArgs = {
              inherit inputs pkgs-unfree pkgs-inputs pkgs-local;
            };
            modules = [ ./nix/home-manager/desktop.nix ];
          };
          "maienm@MICHON-MACBOOK" = home-manager.lib.homeManagerConfiguration {
            inherit pkgs;
            extraSpecialArgs = {
              inherit inputs pkgs-unfree pkgs-inputs pkgs-local;
            };
            modules = [ ./nix/home-manager/macbook.nix ];
          };
        };
      };
    }
  );
}
