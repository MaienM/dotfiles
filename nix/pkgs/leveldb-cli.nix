{ buildGoModule
, fetchFromGitHub
}:
buildGoModule rec {
  pname = "leveldb-cli";
  version = "1.1.1";

  src = fetchFromGitHub {
    owner = "cions";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-pfUmuS5wcSn+tGh0kwuHjHYh8n7S3dpqPSlOL8KefY8=";
  };

  vendorHash = "sha256-YMAXeCCELBJ9aHfxqgh/FDzbXceZm+H10nU/8WjAHuw=";
}
