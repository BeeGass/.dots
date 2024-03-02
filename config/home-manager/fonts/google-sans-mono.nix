{ pkgs, config, lib, ... }:

pkgs.stdenvNoCC.mkDerivation {
  name = "Google-Sans-Mono";
  
  src = pkgs.fetchFromGitHub {
    owner = "mehant-kr";
    repo = "Google-Sans-Mono";
    rev = "2535d60dba86fb711a4a87516de136b8cae92279";
    sha256 = "sha256-0mh5xa7wrwqbhcmbj6f27kz1p4wxh7bcfsln9cjr3abx21lg2b5r";
  };

  dontConfigure = true;

  installPhase = ''
    mkdir -p $out/share/fonts/{opentype,truetype}
    cp $src/*.otf $out/share/fonts/opentype/
    cp $src/*.ttf $out/share/fonts/truetype/
  '';
}
