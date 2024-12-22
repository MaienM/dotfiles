{
  config,
  lib,
  pkgs,
  stdenv,
  ...
}:
with lib;
{
  options.custom.pinentry-auto = {
    enable = mkOption {
      type = types.bool;
      default = true;
      description = "Setup pinentry-auto, a wrapper script that combines a TTY and GUI pinentry.";
    };

    tty = mkPackageOption pkgs "pinentry-tty" {
      default = "pinentry-curses";
    };

    gui = mkPackageOption pkgs "pinentry-gui" {
      default = if stdenv.isDarwin then "pinentry_mac" else "pinentry-qt";
    };
  };

  config.home.packages = lib.mkIf config.custom.pinentry-auto.enable [
    (
      let
        stty = "${pkgs.coreutils}/bin/ssty";
        pinentry-bin = pinentry-pkg: "${pinentry-pkg}/${pinentry-pkg.binaryPath or "bin/pinentry"}";
      in
      pkgs.writeShellScriptBin "pinentry-auto" ''
        use_tty=
        case "$PINENTRY_USER_DATA" in
          TTY=) ;;
          TTY=*) use_tty=$${PINENTRY_USER_DATA#TTY=} ;;
        esac

        # Make sure the tty that is to be used is not broken and not in -echo mode, because if it is using a TTY pinentry will turn into a mess.
        if [ -n "$use_tty" ] && (!${stty} -F "$use_tty" > /dev/null 2>&1 || ${stty} -F "$use_tty" 2>&1 | grep -q '-echo'); then
          use_tty=
        fi

        if [ -n "$use_tty" ]; then
          exec ${pinentry-bin config.custom.pinentry-auto.tty} "$@"
        fi
        exec ${pinentry-bin config.custom.pinentry-auto.gui} "$@"
      ''
    )
  ];
}
