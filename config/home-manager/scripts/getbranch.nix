{ pkgs, ... }: 

let
  git = "${pkgs.git}/bin/git";
  s = "\${remote#origin/}";
in 
pkgs.writeShellScriptBin "allbranches" '' 
    #!/usr/bin/env bash
    ${git} branch -r | grep -v '\->' | sed "s,\x1B\[[0-9;]*[a-zA-Z],,g" | while read remote; do ${git} branch --track ${s} "\$remote"; done
''
