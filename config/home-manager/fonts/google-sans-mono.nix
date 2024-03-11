{ pkgs, lib, stdenvNoCC }:

let
  pname = "google-sans-mono";
  
  fontFiles = pkgs.fetchFromGitHub {
    name = pname;
    owner = "mehant-kr";
    repo = "Google-Sans-Mono";
    rev = "2535d60dba86fb711a4a87516de136b8cae92279";
    sha256 = "sha256-Vh2ruuFDTyjguxbZLOHSWqxzsLnKMOsa1IzYdrXTPEY=";
  };

  monospacer = pkgs.fetchFromGitHub {
    name = "monospacifier";
    owner = "Finii";
    repo = "monospacifier";
    rev = "096a00b7af3de746190f70ca147cd32948fb66ca";
    sha256 = "sha256-QqGRENHajjlBwQGKL9WhOP5D8tdSeFJDvWgmCiX5SKk=";
  };

  font = "\${font}";
in 
stdenvNoCC.mkDerivation {
  name = "${pname}";

  nativeBuildInputs = [ 
    pkgs.python3
    pkgs.fontforge
  ];

  srcs = [ 
    fontFiles
    monospacer
  ];

  sourceRoot = ".";

  installPhase = ''
    echo "Making Directory"
    mkdir -p $out/share/fonts/truetype/

    # Run monospacifier.py on each font file
    echo "Running monospacifier"
    for font in ./google-sans-mono/*.ttf; do
      python ./monospacifier/monospacifier.py --references ${font} --inputs ${font} --save-to "$out/share/fonts/truetype/"
    done
  '';

  meta = with lib; {
    description = "Google Sans Mono (Monospacified)";
    homepage = "https://github.com/mehant-kr/Google-Sans-Mono";
    license = lib.licenses.asl20;
    platforms = lib.platforms.all;
  };
}
