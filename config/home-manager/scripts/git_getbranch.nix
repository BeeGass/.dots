{ git, writeShellScriptBin }:

let
  # Define the path to the git binary from the git package.
  gitCmd = "${git}/bin/git";
in
writeShellScriptBin "allbranches" ''
  function allbranches() {
    ${gitCmd} branch -r | grep -v '\\->' | sed "s,\\x1B\\[[0-9;]*[a-zA-Z],,g" | while read remote; do
      ${gitCmd} branch --track "${remote#origin/}" "$remote";
    done
  }
''

