{ pkgs
, stdenv
, fetchFromGitHub
, prefix ? "nerdfonts_icons_"
}:
let
  script_path = "bin/scripts/lib";
in
stdenv.mkDerivation rec {
  name = "nerdfonts-script";
  version = pkgs.nerdfonts.version;
  src = fetchFromGitHub {
    owner = "ryanoasis";
    repo = "nerd-fonts";
    rev = "v${version}";
    sparseCheckout = [ script_path ];
    sha256 = "BlyohSx1UqizU/E9fJSmcdUeKcIGFn5FzkUN3K3H/+I=";
  };

  buildInputs = [ pkgs.gnused ];
  buildPhase = ''
    cd "${script_path}"

    for fn in i_*.sh; do
      mv "$fn" "${prefix}''${fn#i_}"
    done

    rm "${prefix}all.sh"
    printf "source $out/bin/%q\n" "${prefix}"*.sh > "${prefix}all.sh"
  '';

  installPhase = ''
    chmod +x *.sh
    mkdir -p $out/bin
    cp *.sh $out/bin
  '';
}
