{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-22.11";

    darwin.url = "github:lnl7/nix-darwin/master";
    darwin.inputs.nixpkgs.follows = "nixpkgs";

    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    neovim.url = "github:neovim/neovim?dir=contrib";
    neovim.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = { nixpkgs, darwin, home-manager, ... }@inputs: {
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
          pkgs-unfree = import "${nixpkgs}" {
            system = "x86_64-linux";
            config.allowUnfree = true;
          };
          pkgs-inputs = nixpkgs.lib.mapAttrs (_: value: value.packages.x86_64-linux) inputs;
        };
        modules = [ ./nix/home-manager/home.nix ];
      };
      "maienm@MICHON-MACBOOK" = home-manager.lib.homeManagerConfiguration {
        pkgs = nixpkgs.legacyPackages.aarch64-darwin;
        extraSpecialArgs = {
          inherit inputs;
          pkgs-unfree = import "${nixpkgs}" {
            system = "aarch64-darwin";
            config.allowUnfree = true;
          };
          pkgs-inputs = nixpkgs.lib.mapAttrs (_: value: value.packages.aarch64-darwin) inputs;
        };
        modules = [ ./nix/home-manager/home.nix ];
      };
    };
  };
}
