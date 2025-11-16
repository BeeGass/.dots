# Btrfs automatic snapshots module
{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.myHomelab.storage.btrfsSnapshots;
in
{
  options.myHomelab.storage.btrfsSnapshots = {
    enable = mkEnableOption "automatic btrfs snapshots";

    schedule = mkOption {
      type = types.str;
      default = "hourly";
      description = "Snapshot schedule (systemd calendar format)";
    };

    retention = mkOption {
      type = types.str;
      default = "48h 7d 4w 12m";
      description = "Snapshot retention policy";
    };

    subvolumes = mkOption {
      type = types.listOf types.str;
      default = [ "home" "nix" "var/log" ];
      description = "Btrfs subvolumes to snapshot";
    };
  };

  config = mkIf cfg.enable {
    services.btrbk = {
      instances.main = {
        onCalendar = cfg.schedule;
        settings = {
          timestamp_format = "long";
          snapshot_preserve = cfg.retention;
          snapshot_preserve_min = "6h";

          volume."/" = mkMerge (map (subvol: {
            subvolume.${subvol} = {
              snapshot_dir = ".snapshots/${subvol}";
              snapshot_create = "always";
            };
          }) cfg.subvolumes);
        };
      };
    };

    environment.systemPackages = with pkgs; [
      btrbk
    ];

    systemd.tmpfiles.rules = [
      "d /.snapshots 0755 root root -"
    ] ++ map (subvol: "d /.snapshots/${subvol} 0755 root root -") cfg.subvolumes;
  };
}
