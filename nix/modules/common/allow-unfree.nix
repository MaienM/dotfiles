{ config, lib, ... }:
{
  options = {
    custom.allowUnfreeList = lib.mkOption {
      type = lib.types.listOf (lib.types.strMatching "[^[:space:]]+");
      default = [ ];
      description = "The set of unfree package names to allow";
    };
  };

  config = {
    nixpkgs.config.allowUnfreePredicate =
      pkg: builtins.elem (lib.getName pkg) config.custom.allowUnfreeList;
  };
}
