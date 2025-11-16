# Disko configuration template for VMs and simple systems (VM, Default)
#
# Features:
# - UEFI boot with systemd-boot
# - Simple ext4 root filesystem
# - No subvolumes or advanced features
# - No swap
# - No encryption
#
# Usage: Import this template in per-host disko-config.nix and override:
#   - device: actual device path (/dev/sda, /dev/vda, etc.)

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

            # Simple ext4 root partition
            root = {
              size = "100%";  # Use all remaining space
              content = {
                type = "filesystem";
                format = "ext4";
                mountpoint = "/";
                mountOptions = [
                  "noatime"
                ];
              };
            };
          };
        };
      };
    };
  };
}
