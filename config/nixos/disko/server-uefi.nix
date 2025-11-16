# Disko configuration template for servers (home-server, remote-server)
#
# Features:
# - UEFI boot with systemd-boot
# - Btrfs root with compression and subvolumes (enables snapshots)
# - Separate subvolume for services/data
# - No swap (servers typically have sufficient RAM)
# - No encryption (can be added per-host if needed)
#
# Usage: Import this template in per-host disko-config.nix and override:
#   - device: actual device path

{ device ? "/dev/sda"
, ...
}:

{
  disko.devices = {
    disk = {
      main = {
        type = "disk";
        inherit device;
        content = {
          type = "gpt";
          partitions = {
            # EFI System Partition (ESP)
            ESP = {
              size = "512M";
              type = "EF00";
              content = {
                type = "filesystem";
                format = "vfat";
                mountpoint = "/boot";
                mountOptions = [
                  "defaults"
                  "umask=0077"  # Restrict permissions for security
                ];
              };
            };

            # Btrfs root partition with subvolumes
            root = {
              size = "100%";  # Use all remaining space
              content = {
                type = "btrfs";
                extraArgs = [ "-f" ];  # Force overwrite
                subvolumes = {
                  # Root subvolume
                  "@" = {
                    mountpoint = "/";
                    mountOptions = [
                      "noatime"
                      "compress=zstd"
                      "space_cache=v2"
                      "discard=async"
                    ];
                  };

                  # Home subvolume
                  "@home" = {
                    mountpoint = "/home";
                    mountOptions = [
                      "noatime"
                      "compress=zstd"
                      "discard=async"
                    ];
                  };

                  # Nix store subvolume
                  "@nix" = {
                    mountpoint = "/nix";
                    mountOptions = [
                      "noatime"
                      "compress=zstd"
                      "space_cache=v2"
                      "discard=async"
                    ];
                  };

                  # Services/data subvolume (can be snapshotted independently)
                  "@srv" = {
                    mountpoint = "/srv";
                    mountOptions = [
                      "noatime"
                      "compress=zstd"
                      "discard=async"
                    ];
                  };

                  # Logs subvolume
                  "@log" = {
                    mountpoint = "/var/log";
                    mountOptions = [
                      "noatime"
                      "compress=zstd"
                    ];
                  };
                };
              };
            };
          };
        };
      };
    };
  };
}
