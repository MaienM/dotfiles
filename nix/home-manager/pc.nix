{ pkgs, pkgs-unfree, pkgs-local, ... }:
{
  imports = [
    ./common.nix
    (import ./gpg-agent.nix {
      pinentry = pkgs-local.pinentry-auto;
    })
  ];

  home.username = "maienm";
  home.homeDirectory = "/home/maienm";

  xsession = {
    enable = true;
    windowManager.command = "${pkgs.i3-gaps}/bin/i3";
  };

  services.gnome-keyring = {
    enable = true;
    components = [ "secrets" ];
  };

  home.packages = with pkgs;
    [

      # WM.
      dunst
      i3-gaps # gaps has been merged into i3, but no release has happened since
      maim
      picom
      polybarFull
      redshift
      rofi
      scrot
      xorg.xkill
      yubikey-touch-detector

      (
        python3.pkgs.buildPythonApplication rec {
          pname = "notify-send.py";
          version = "1.2.7";
          src = python3.pkgs.fetchPypi {
            inherit pname version;
            sha256 = "9olZRJ9q1mx1hGqUal6XdlZX6v5u/H1P/UqVYiw9lmM=";
          };
          propagatedBuildInputs = with python3.pkgs; [ pygobject3 dbus-python ];
        }
      )

      # CLI.
      cached-nix-shell

      # Applications.
      feh
      firefox
      mpv
      pavucontrol
      pkgs-unfree.discord
      pkgs-unfree.google-chrome
      qpwgraph
      retroarchFull
      steam-rom-manager
      workrave

    ];

  # Autostart new user systemd services.
  systemd.user.startServices = "sd-switch";

  # Setup synergy connection with macbook.
  systemd.user.services.synergy = {
    Unit.Description = "Run synergy to share mouse & keyboard with macbook.";
    Unit.PartOf = "graphical-session.target";
    Service.Type = "simple";
    Service.ExecStart = builtins.toString [
      "${pkgs.synergyWithoutGUI}/bin/synergys"
      "--name DESKTOP"
      "--config ${builtins.toFile "synergy.conf" ''
        section: screens
          DESKTOP:
            halfDuplexCapsLock = false
            halfDuplexNumLock = false
            halfDuplexScrollLock = false
            xtestIsXineramaUnaware = false
            switchCorners = none 
            switchCornerSize = 0
          MACBOOK:
            halfDuplexCapsLock = false
            halfDuplexNumLock = false
            halfDuplexScrollLock = false
            xtestIsXineramaUnaware = false
            switchCorners = none 
            switchCornerSize = 0
            ctrl = meta
            meta = ctrl
        end

        section: aliases
        end

        section: links
          DESKTOP:
            down(0,100) = MACBOOK(0,100)
          MACBOOK:
            up = DESKTOP
        end

        section: options
          relativeMouseMoves = false
          win32KeepForeground = false
          disableLockToScreen = false
          clipboardSharing = true
          clipboardSharingSize = 3072
          switchCorners = none
          switchCornerSize = 0
        end
      ''}"
      "--no-daemon"
      "--address localhost:24800"
    ];
    Install.WantedBy = [ "graphical-session.target" ];
    Service.Restart = "always";
    Service.RestartSec = 0;
  };
  home.file.".ssh/config.d/macbook-synergy".text = ''
    Host macbook
      RemoteForward 24800 localhost:24800
  '';
}
