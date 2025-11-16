# Disko configuration for Manifold - Dual-boot Windows/NixOS setup
#
# This configuration assumes Windows is ALREADY INSTALLED on /dev/nvme0n1
# and has created its partitions (ESP, MSR, Windows C:, Recovery).
#
# IMPORTANT: This is a REFERENCE configuration for manual installation.
# Disko cannot safely partition a drive that already has Windows on it.
#
# Installation Steps:
# 1. Install Windows first, let it use ~1TB of the 2TB drive
# 2. Use Windows Disk Management or diskpart to shrink the Windows partition
# 3. Manually create the NixOS partition in the free space (~998GB)
# 4. Use this config as a REFERENCE for fileSystems configuration
# 5. DO NOT run disko's partitioning - only use for fileSystems generation
#
# Hardware:
# - Device 1: /dev/nvme0n1 (2TB) - OS drive (Windows + NixOS)
# - Device 2: /dev/nvme1n1 (2TB) - Data drive (pure XFS)

{ ... }:

{
  disko.devices = {
    disk = {
      # OS Drive - Contains Windows and NixOS
      os = {
        type = "disk";
        device = "/dev/nvme0n1";
        content = {
          type = "gpt";
          partitions = {
            # ESP - Shared with Windows (already created by Windows)
            # Partition 1: EFI System Partition
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

            # Partition 2: MSR (Windows, do not touch)
            # Partition 3: Windows C: drive (do not touch)
            # Partition 4: Windows Recovery (do not touch)

            # Partition 5: NixOS Root (~998GB btrfs)
            # NOTE: In reality, you will manually create this partition
            # after shrinking Windows. This is just for reference.
            root = {
              size = "998G";
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
          };
        };
      };

      # Data Drive - Pure XFS for ML datasets and models
      data = {
        type = "disk";
        device = "/dev/nvme1n1";
        content = {
          type = "gpt";
          partitions = {
            data = {
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
    };
  };
}
