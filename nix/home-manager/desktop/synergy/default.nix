{ pkgs, ... }:
let
  synergy = pkgs.synergyWithoutGUI.overrideAttrs (old: {
    patches = old.patches ++ [ ./middle-screen.patch ];
  });
in
{
  systemd.user.services.synergy = {
    Unit.Description = "Run synergy to share mouse & keyboard with macbook.";
    Unit.PartOf = "graphical-session.target";
    Service.Type = "simple";
    Service.ExecStart = builtins.toString [
      "${synergy}/bin/synergys"
      "--name DESKTOP"
      "--config ${./synergy.conf}"
      "--no-daemon"
      "--address localhost:24800"
    ];
    Install.WantedBy = [ "graphical-session.target" ];
    Service.Restart = "always";
    Service.RestartSec = 0;
  };
  home.file.".ssh/config.d/macbook-synergy".source = ./ssh-config;
}
