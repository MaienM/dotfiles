{ config, lib, pkgs, pkgs-local, ... }:
with lib;
let
  cfg = config.services.VPNStatus;
  pkg = pkgs-local.VPNStatus.VPNStatus;
in
{
  options.services.VPNStatus = {
    enable = mkEnableOption "VPNStatus, a replacement for macOS builtin VPN Status";

    retryDelay = mkOption {
      type = types.int;
      default = 120;
      example = 30;
      description = ''
        The amount of time in seconds between attempts to reconnect to any VPN that are set to always reconnect.

        Note that the minimum valid value is 11. If you use a lower value, the default value (120s) will be used.
      '';
    };

    ignoredSSIDs = mkOption {
      type = types.listOf types.str;
      default = [ ];
      example = [ ];
      description = ''
        VPNStatus can optionally ignore one or more SSIDs, such that services are not autoconnected when the current
        Wi-Fi SSID is on the ignored list.

        Note that SSIDs are case-sensitive.
      '';
    };
  };

  config = mkIf cfg.enable {
    home.packages = [ pkg ];

    launchd.agents.VPNStatus = {
      enable = true;
      config = {
        ProgramArguments = [
          "open"
          "${pkg}/Applications/VPNStatus.app"
        ];
        KeepAlive = true;
        ThrottleInterval = 30;
        ExitTimeOut = 0;
        RunAtLoad = true;
      };
    };

    targets.darwin.defaults."org.timac.VPNStatus" = {
      AlwaysConnectedRetryDelay = cfg.retryDelay;
      IgnoredSSIDs = cfg.ignoredSSIDs;
    };
  };
}
