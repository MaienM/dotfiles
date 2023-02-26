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
  version = "2.3.3";
  src = fetchFromGitHub {
    owner = "ryanoasis";
    repo = "nerd-fonts";
    rev = "v${version}";
    sparseCheckout = [ script_path ];
    sha256 = "ei61TDUA11omroDl0CyjBOKVH6aQJm4Wxmj9jOI3f8s=";
  };

  buildInputs = [ pkgs.gnused ];
  buildPhase = ''
    ${if version != pkgs.nerdfonts.version
      then ''
        >&2 echo "${name} is out of date with base nerdfonts package, please update it.";
        exit 1
      ''
      else ""
    }

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
