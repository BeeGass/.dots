{ pkgs }:

let
  setup-gpg-ssh = pkgs.writeShellScriptBin "setup-gpg-ssh" (builtins.readFile ../assets/scripts/setup_gpg_ssh.sh);

  yk-status = pkgs.writeShellScriptBin "yk-status" (builtins.readFile ../assets/scripts/yk-status.sh);

  yk-lock = pkgs.writeShellScriptBin "yk-lock" (builtins.readFile ../assets/scripts/yk-lock.sh);

  yk-gpg-refresh = pkgs.writeShellScriptBin "yk-gpg-refresh" (builtins.readFile ../assets/scripts/yk-gpg-refresh.sh);
in
{
  inherit setup-gpg-ssh yk-status yk-lock yk-gpg-refresh;

  all = [
    setup-gpg-ssh
    yk-status
    yk-lock
    yk-gpg-refresh
  ];
}
