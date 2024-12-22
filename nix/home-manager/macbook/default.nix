{
  pkgs,
  stdenv,
  ...
}:
{
  imports = [
    (if stdenv.isDarwin then ./darwin.nix else ./linux.nix)
  ];

  # Autostart synergyc.
  launchd.agents.synergy = {
    enable = true;
    config = {
      ProgramArguments = [
        "${pkgs.synergyWithoutGUI}/bin/synergyc"
        "--name"
        "MACBOOK"
        "--no-daemon"
        "localhost:24800"
      ];
      KeepAlive = true;
      ThrottleInterval = 30;
      ExitTimeOut = 0;
      RunAtLoad = true;
    };
  };
}
