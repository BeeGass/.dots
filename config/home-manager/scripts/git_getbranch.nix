{ pkgs, git, writeShellScriptBin }:

let
  gitCmd = "${git}/bin/git";
in
pkgs.writeShellScriptBin "allbranches" ''
  function allbranches() {
    ${gitCmd} branch -r | grep -v '\\->' | sed "s,\\x1B\\[[0-9;]*[a-zA-Z],,g" | while read remote; do
      ${gitCmd} branch --track "$${remote#origin/}" "$$remote";
    done
  }

  allbranches
''

