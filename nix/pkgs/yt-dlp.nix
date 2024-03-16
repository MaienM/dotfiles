{ pkgs
, ...
}:
let
  plugin-oauth2 = with pkgs.python3.pkgs; buildPythonPackage rec {
    pname = "yt-dlp-youtube-oauth2";
    version = "f71ab0fd71dbcf6885316d45d904e68d2fcc3a30";
    src = pkgs.fetchFromGitHub {
      owner = "coletdjnz";
      repo = pname;
      rev = version;
      hash = "sha256-i7qzq3vFcLQ+lt0u2SO26ZizGUg7yuu/Xphkl/UXNB4=";
    };
    format = "pyproject";
    buildInputs = [
      setuptools
    ];
  };
in
pkgs.yt-dlp.overrideAttrs (old: {
  propagatedBuildInputs = old.propagatedBuildInputs ++ [ plugin-oauth2 ];
  setupPyBuildFlags = builtins.filter (flag: flag != "build_lazy_extractors") old.setupPyBuildFlags;
})
