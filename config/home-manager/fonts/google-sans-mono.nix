{ lib, stdenvNoCC, fetchFromGitHub }:

let
  pname = "google-sans-mono";
  version = "1.0"; # You can define any version you prefer
in stdenvNoCC.mkDerivation {
  name = "${pname}-${version}";

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

#{ pkgs, config, lib, ... }:
#
#pkgs.stdenvNoCC.mkDerivation {
#  name = "google-sans-mono";
#  
#  src = pkgs.fetchFromGitHub {
#    owner = "mehant-kr";
#    repo = "Google-Sans-Mono";
#    rev = "2535d60dba86fb711a4a87516de136b8cae92279";
#    hash = "sha256-Vh2ruuFDTyjguxbZLOHSWqxzsLnKMOsa1IzYdrXTPEY=";
#  };
#
#  dontConfigure = true;
#
#  installPhase = ''
#    mkdir -p $out/share/fonts/opentype/
#    mkdir -p $out/share/fonts/truetype/
#    for file in $src/*.otf; do
#      cp "$file" $out/share/fonts/opentype/
#    done
#    for file in $src/*.ttf; do
#      cp "$file" $out/share/fonts/truetype/
#      install -m444 -Dt $out/share/fonts/truetype fonts/ttf/*.ttf
#    done
#  '';
#
#
#}

#{ pkgs, lib, fetchFromGitHub, ... }:
#
#fetchFromGitHub {
#  name = "google-sans-mono";
#  
#  owner = "mehant-kr";
#  repo = "Google-Sans-Mono";
#  rev = "2535d60dba86fb711a4a87516de136b8cae92279";
#  hash = "sha256-Vh2ruuFDTyjguxbZLOHSWqxzsLnKMOsa1IzYdrXTPEY=";
#
#  postFetch = ''
#    tar xf $downloadedFile --strip=1
#    install -m444 -Dt $out/share/fonts/truetype fonts/ttf/*.ttf
#  '';
#}
