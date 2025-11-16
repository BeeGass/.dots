# Disko configuration template for ML workstations (Tensor, Manifold)
#
# Features:
# - UEFI boot with systemd-boot
# - Btrfs root with compression and subvolumes
# - Separate XFS /data partition for ML datasets and models
# - No swap (sufficient RAM for ML workloads)
# - No encryption (homelab environment)
#
# Usage: Import this template in per-host disko-config.nix and override:
#   - device: actual NVMe device path
#   - rootSize: size of root partition (rest goes to /data)

{ device ? "/dev/nvme0n1"
, rootSize ? "200G"
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
              size = rootSize;
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
                      "ssd"
                      "discard=async"
                    ];
                  };

                  # Home subvolume
                  "@home" = {
                    mountpoint = "/home";
                    mountOptions = [
                      "noatime"
                      "compress=zstd"
                      "ssd"
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
                      "ssd"
                      "discard=async"
                    ];
                  };

                  # Logs subvolume (compressed, can be snapshotted independently)
                  "@log" = {
                    mountpoint = "/var/log";
                    mountOptions = [
                      "noatime"
                      "compress=zstd"
                      "ssd"
                    ];
                  };
                };
              };
            };

            # XFS data partition for ML datasets and models
            # XFS excels at handling large files and parallel I/O
            data = {
              size = "100%";  # Use all remaining space
              content = {
                type = "filesystem";
                format = "xfs";
                mountpoint = "/data";
                mountOptions = [
                  "noatime"       # Don't update access times
                  "nodiratime"    # Don't update directory access times
                  "logbufs=8"     # Increase log buffers for performance
                  "logbsize=256k" # Larger log buffer size
                ];
              };
            };
          };
        };
      };
    };
  };
}
