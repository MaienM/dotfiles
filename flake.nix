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

  outputs = { nixpkgs, flake-utils, darwin, home-manager, ... }@inputs:
    let
      # ( system -> something } -> { system = something }
      eachDefaultSystemBySystem =
        (func:
          builtins.listToAttrs (
            builtins.map
              (system: {
                name = system;
                value = func system;
              })
              flake-utils.lib.defaultSystems
          )
        );
      # { system = nixpkgs.${system} with unfree allowed }
      pkgs-unfree = eachDefaultSystemBySystem (system:
        import "${nixpkgs}" {
          inherit system;
          config.allowUnfree = true;
        }
      );
      # { system = { name = inputs.${name}.packages.${system} } }
      pkgs-inputs = eachDefaultSystemBySystem (system:
        builtins.mapAttrs
          (_: nixpkgs.lib.attrByPath [ "packages" system ] { })
          inputs
      );
      );
    in
    {
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
          pkgs = nixpkgs.legacyPackages.x86_64-linux;
          extraSpecialArgs = {
            inherit inputs;
            pkgs-unfree = pkgs-unfree.x86_64-linux;
            pkgs-inputs = pkgs-inputs.x86_64-linux;
          };
          modules = [ ./nix/home-manager/pc.nix ];
        };
        "maienm@MICHON-MACBOOK" = home-manager.lib.homeManagerConfiguration {
          pkgs = nixpkgs.legacyPackages.aarch64-darwin;
          extraSpecialArgs = {
            inherit inputs;
            pkgs-unfree = pkgs-unfree.aarch64-darwin;
            pkgs-inputs = pkgs-inputs.aarch64-darwin;
          };
          modules = [ ./nix/home-manager/macbook.nix ];
        };
      };
    };
}
