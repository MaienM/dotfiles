{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    flake-utils.url = "github:numtide/flake-utils";

    darwin.url = "github:lnl7/nix-darwin/master";
    darwin.inputs.nixpkgs.follows = "nixpkgs";

    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    neovim.url = "github:neovim/neovim?dir=contrib";
    # neovim.inputs.nixpkgs.follows = "nixpkgs"; # Doesn't work with unstable.
    neovim.inputs.flake-utils.follows = "flake-utils";

    neovim-darwin.url = "github:neovim/neovim/c54592bfdacf08823a03d5aa251f49b906f3157d?dir=contrib";
    neovim-darwin.inputs.flake-utils.follows = "flake-utils";
  };

  outputs = { nixpkgs, flake-utils, darwin, home-manager, ... }@inputs: flake-utils.lib.eachDefaultSystem (system:
    let
      dotfiles = ./.;
      pkgs = nixpkgs.legacyPackages.${system};
      pkgs-inputs = # { name = inputs.${name}.packages.${system} }
        builtins.mapAttrs
          (_: nixpkgs.lib.attrByPath [ "packages" system ] { })
          inputs;
      pkgs-local = import ./nix/pkgs {
        inherit inputs system pkgs pkgs-inputs pkgs-local;
      };

      dot-nixos-rebuild = pkgs.writeShellApplication {
        name = "dot-nixos-rebuild";
        runtimeInputs = [ pkgs.nixos-rebuild ];
        text = ''
          sudo nixos-rebuild --flake "$HOME/dotfiles#''${HOSTNAME:-$(hostname)}" "$@"
        '';
      };
      dot-darwin-rebuild =
        if pkgs-inputs.darwin ? "darwin-rebuild" && pkgs-inputs.darwin.darwin-rebuild.meta.available
        then
          pkgs.writeShellApplication
            {
              name = "dot-darwin-rebuild";
              runtimeInputs = [ pkgs-inputs.darwin.darwin-rebuild ];
              text = ''
                darwin-rebuild --flake "$HOME/dotfiles#''${HOSTNAME:-$(hostname)}" "$@"
              '';
            }
        else pkgs.empty;
      dot-home-manager = pkgs.writeShellApplication {
        name = "dot-home-manager";
        runtimeInputs = [ pkgs-inputs.home-manager.home-manager ];
        text = ''
          home-manager --flake "$HOME/dotfiles#$USER@''${HOSTNAME:-$(hostname)}" "$@"
        '';
      };
    in
    {
      packages = {
        inherit (pkgs) nixos-rebuild;
        inherit (pkgs-inputs.darwin) darwin-rebuild;
        inherit (pkgs-inputs.home-manager) home-manager;
        inherit dot-nixos-rebuild dot-darwin-rebuild dot-home-manager;

        nixosConfigurations = {
          MICHON-PC = nixpkgs.lib.nixosSystem {
            specialArgs = {
              inherit inputs dotfiles pkgs-inputs pkgs-local;
            };
            modules = [
              ./nix/modules/nixos
              ./nix/nixos/desktop
            ];
          };
        };

        darwinConfigurations = {
          MICHON-MACBOOK = darwin.lib.darwinSystem {
            specialArgs = {
              inherit inputs dotfiles pkgs-inputs pkgs-local;
            };
            system = "aarch64-darwin";
            modules = [
              ./nix/modules/darwin
              ./nix/darwin/macbook
            ];
          };
        };

        homeConfigurations = {
          "maienm@MICHON-PC" = home-manager.lib.homeManagerConfiguration {
            inherit pkgs;
            extraSpecialArgs = {
              inherit inputs dotfiles pkgs-inputs pkgs-local;
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
              inherit inputs dotfiles pkgs-inputs pkgs-local;
            };
            modules = [
              ./nix/modules/home-manager
              ./nix/home-manager/common.nix
              ./nix/home-manager/macbook
            ];
          };
          "maienm@neptune" = home-manager.lib.homeManagerConfiguration {
            inherit pkgs;
            extraSpecialArgs = {
              inherit inputs dotfiles pkgs-inputs pkgs-local;
            };
            modules = [
              ./nix/modules/home-manager
              ./nix/home-manager/common.nix
              ./nix/home-manager/neptune.nix
            ];
          };
        };
      };

      devShell = pkgs.mkShell {
        buildInputs = with pkgs; [
          dot-nixos-rebuild
          dot-darwin-rebuild
          dot-home-manager

          python3
          python3.pkgs.pytest
        ];
      };
    }
  );
}
