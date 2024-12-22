{
  pkgs,
}:
if pkgs.cached-nix-shell.meta.available then
  pkgs.cached-nix-shell
else
  pkgs.writeShellApplication {
    name = "cached-nix-shell";
    runtimeInputs = with pkgs; [ nix ];
    text = ''
      exec nix-shell "$@"
    '';
  }
