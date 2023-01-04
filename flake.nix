{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-22.11";

    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = { nixpkgs, home-manager, ... }@inputs: {
    # dot-nixos-rebuild (which is an alias for nixos-rebuild --flake .#your-hostname).
    nixosConfigurations = {
      MICHON-PC = nixpkgs.lib.nixosSystem {
        specialArgs = { inherit inputs; };
        modules = [ ./nix/nixos/configuration.nix ];
      };
    };

    # dot-home-manager (which is an alias for home-manager --flake .#your-username@your-hostname).
    homeConfigurations = {
      "maienm@MICHON-PC" = home-manager.lib.homeManagerConfiguration {
        pkgs = nixpkgs.legacyPackages.x86_64-linux;
        extraSpecialArgs = { inherit inputs; };
        modules = [ ./nix/home-manager/home.nix ];
      };
    };
  };
}
