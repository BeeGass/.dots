# Disko configuration for Tensor - Multi-drive ML workstation
#
# Hardware:
# - Device 1: /dev/nvme0n1 (1TB) - Mixed OS/Data drive
# - Device 2: /dev/nvme1n1 (2TB) - Pure data drive
# - Device 3: /dev/nvme2n1 (2TB) - Pure data drive
#
# This gives you:
# - /boot (1GB) - ESP on first drive
# - / (500GB btrfs) - OS with subvolumes on first drive
# - /data (~499GB xfs) - First data partition on first drive
# - /data2 (2TB xfs) - Second data drive
# - /data3 (2TB xfs) - Third data drive
#
# Total data capacity: ~4.5TB across three XFS partitions

{ ... }:

{
  disko.devices = {
    disk = {
      # Drive 1: Mixed OS/Data (1TB)
      nvme0 = {
        type = "disk";
        device = "/dev/nvme0n1";
        content = {
          type = "gpt";
          partitions = {
            # EFI System Partition
            ESP = {
              size = "1G";
              type = "EF00";
              content = {
                type = "filesystem";
                format = "vfat";
                mountpoint = "/boot";
                mountOptions = [
                  "defaults"
                  "umask=0077"
                ];
              };
            };

            # Btrfs root partition (500GB)
            root = {
              size = "500G";
              content = {
                type = "btrfs";
                extraArgs = [ "-f" ];
                subvolumes = {
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
                  "@home" = {
                    mountpoint = "/home";
                    mountOptions = [
                      "noatime"
                      "compress=zstd"
                      "ssd"
                      "discard=async"
                    ];
                  };
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

            # XFS data partition (~499GB - remaining space)
            data1 = {
              size = "100%";
              content = {
                type = "filesystem";
                format = "xfs";
                mountpoint = "/data";
                mountOptions = [
                  "noatime"
                  "nodiratime"
                  "logbufs=8"
                  "logbsize=256k"
                ];
              };
            };
          };
        };
      };

      # Drive 2: Pure Data (2TB)
      nvme1 = {
        type = "disk";
        device = "/dev/nvme1n1";
        content = {
          type = "gpt";
          partitions = {
            data2 = {
              size = "100%";
              content = {
                type = "filesystem";
                format = "xfs";
                mountpoint = "/data2";
                mountOptions = [
                  "noatime"
                  "nodiratime"
                  "logbufs=8"
                  "logbsize=256k"
                ];
              };
            };
          };
        };
      };

      # Drive 3: Pure Data (2TB)
      nvme2 = {
        type = "disk";
        device = "/dev/nvme2n1";
        content = {
          type = "gpt";
          partitions = {
            data3 = {
              size = "100%";
              content = {
                type = "filesystem";
                format = "xfs";
                mountpoint = "/data3";
                mountOptions = [
                  "noatime"
                  "nodiratime"
                  "logbufs=8"
                  "logbsize=256k"
                ];
              };
            };
          };
        };
      };
    };
  };
}
