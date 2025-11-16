# Secrets management module using sops-nix
{ config, lib, pkgs, inputs, ... }:

with lib;

let
  cfg = config.myHomelab.security.secrets;
in
{
  options.myHomelab.security.secrets = {
    enable = mkEnableOption "sops-nix secrets management";

    secretsFile = mkOption {
      type = types.path;
      default = ../../secrets/secrets.yaml;
      description = "Path to encrypted secrets file";
    };

    useAge = mkOption {
      type = types.bool;
      default = true;
      description = "Use age for encryption (simpler than GPG)";
    };
  };

  config = mkIf cfg.enable {
    sops = {
      defaultSopsFile = cfg.secretsFile;

      age = mkIf cfg.useAge {
        keyFile = "/var/lib/sops-nix/key.txt";
        generateKey = true;
      };
    };

    environment.systemPackages = with pkgs; [
      sops
    ] ++ optional cfg.useAge age;

    systemd.tmpfiles.rules = [
      "d /var/lib/sops-nix 0755 root root -"
    ];
  };
}
