{ pkgs
, system
, pinentry-tty ? "${pkgs.pinentry-curses}/bin/pinentry"
, pinentry-gui ? "${pkgs.pinentry-qt}/bin/pinentry"
, ...
}:
let
  stty = "${pkgs.coreutils}/bin/ssty";
in
pkgs.writeShellScriptBin "pinentry" ''
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
    exec ${pinentry-tty} "$@"
  fi
  exec ${pinentry-gui} "$@"
''

