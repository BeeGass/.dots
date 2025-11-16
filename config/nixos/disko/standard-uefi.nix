# Disko configuration template for standard systems (Desktop, Laptop, Macbook)
#
# Features:
# - UEFI boot with systemd-boot
# - Btrfs root with compression and subvolumes
# - No separate data partition
# - No swap (sufficient RAM)
# - No encryption (homelab environment)
#
# Usage: Import this template in per-host disko-config.nix and override:
#   - device: actual device path (/dev/sda, /dev/nvme0n1, etc.)

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

                  # Nix store subvolume (benefits from compression)
                  "@nix" = {
                    mountpoint = "/nix";
                    mountOptions = [
                      "noatime"
                      "compress=zstd"
                      "space_cache=v2"
                      "discard=async"
                    ];
                  };

                  # Logs subvolume (compressed, can be snapshotted independently)
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
