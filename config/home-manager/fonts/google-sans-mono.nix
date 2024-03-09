{ lib, stdenvNoCC, fetchFromGitHub }:

let
  pname = "google-sans-mono";
in stdenvNoCC.mkDerivation {
  name = "${pname}";

  src = fetchFromGitHub {
    owner = "mehant-kr";
    repo = "Google-Sans-Mono";
    rev = "2535d60dba86fb711a4a87516de136b8cae92279";
    sha256 = "sha256-Vh2ruuFDTyjguxbZLOHSWqxzsLnKMOsa1IzYdrXTPEY=";
  };

  installPhase = ''
    mkdir -p $out/share/fonts/truetype
    cp -R $src/*.ttf $out/share/fonts/truetype/
  '';

  meta = with lib; {
    description = "Google Sans Mono";
    homepage = "https://github.com/mehant-kr/Google-Sans-Mono";
    license = lib.licenses.asl20; # Adjust the license accordingly
    platforms = lib.platforms.all;
  };
}
