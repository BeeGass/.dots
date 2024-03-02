{ lib, stdenvNoCC, fetchFromGitHub }:

let
  pname = "google-sans";
  version = "1.0"; # You can define any version you prefer
in stdenvNoCC.mkDerivation {
  name = "${pname}-${version}";

  src = fetchFromGitHub {
    owner = "hprobotic";
    repo = "Google-Sans-Font";
    rev = "ce4644946bd4e662fec8cf9736b3f99fefa7d308";
    hash = "sha256-87dKgkb27+O3Y3qQ203PDY3yLCduvIj7hFfNAV9gLOA=";
  };

  installPhase = ''
    mkdir -p $out/share/fonts/truetype
    cp -R $src/*.ttf $out/share/fonts/truetype/
  '';

  meta = with lib; {
    description = "Google Sans Font";
    homepage = "https://github.com/hprobotic/Google-Sans-Font";
    license = lib.licenses.asl20; # Adjust the license accordingly
    platforms = lib.platforms.all;
  };
}
