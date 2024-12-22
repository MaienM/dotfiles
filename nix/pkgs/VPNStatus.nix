{
  pkgs,
  stdenv,
  ...
}:
{
  VPNStatus = stdenv.mkDerivation {
    name = "VPNStatus";

    src = pkgs.fetchzip {
      url = "https://github.com/Timac/VPNStatus/releases/download/1.3/VPNStatus.app.zip";
      sha256 = "JSPx3XwQDLgipV5wV+JHE949mo2AZN6uoC4WnMrPVM8=";
      stripRoot = false;
    };

    installPhase = ''
      mkdir -p $out/Applications
      cp -r VPNStatus.app $out/Applications
    '';
  };
  VPNApp = stdenv.mkDerivation {
    name = "VPNApp";

    src = pkgs.fetchzip {
      url = "https://github.com/Timac/VPNStatus/releases/download/1.3/VPNApp.app.zip";
      sha256 = "goPXJn8rqvfD0DDZkueGSlWQ4BVnWXHPjDh/49bKO/E=";
      stripRoot = false;
    };

    installPhase = ''
      mkdir -p $out/Applications
      cp -r VPNApp.app $out/Applications
    '';
  };
  vpnutil = stdenv.mkDerivation {
    name = "vpnutil";

    src = pkgs.fetchzip {
      url = "https://github.com/Timac/VPNStatus/releases/download/1.3/vpnutil.zip";
      sha256 = "DgyDR8uJfifXFsJXvvDBRdLGLDS5F9h6fTTsk7q8FzI=";
    };

    installPhase = ''
      mkdir -p $out/bin
      cp vpnutil $out/bin
    '';
  };
}
