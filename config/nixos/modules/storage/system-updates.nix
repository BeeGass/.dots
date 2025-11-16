# Automatic system updates module
{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.myHomelab.storage.autoUpdate;
in
{
  options.myHomelab.storage.autoUpdate = {
    enable = mkEnableOption "automatic system updates";

    schedule = mkOption {
      type = types.str;
      default = "Sun *-*-* 04:30:00";
      description = "Update schedule (systemd calendar format)";
    };

    flakePath = mkOption {
      type = types.str;
      default = "git+file:///home/beegass/.dots";
      description = "Path to flake configuration";
    };

    allowReboot = mkOption {
      type = types.bool;
      default = false;
      description = "Allow automatic reboots if needed";
    };

    gcRetention = mkOption {
      type = types.str;
      default = "30d";
      description = "Garbage collection retention period";
    };
  };

  config = mkIf cfg.enable {
    system.autoUpgrade = {
      enable = true;
      flake = cfg.flakePath;
      flags = [
        "--update-input" "nixpkgs"
        "--update-input" "home-manager"
        "--commit-lock-file"
        "-L"
      ];
      dates = cfg.schedule;
      randomizedDelaySec = "1h";
      allowReboot = cfg.allowReboot;
    };

    nix.gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than ${cfg.gcRetention}";
    };

    nix.optimise = {
      automatic = true;
      dates = [ "weekly" ];
    };

    environment.systemPackages = with pkgs; [
      nix-output-monitor
    ];
  };
}
