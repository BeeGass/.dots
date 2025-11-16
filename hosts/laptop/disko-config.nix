# Disko disk configuration for Laptop
#
# Standard btrfs layout for laptop system
#
# ⚠️  IMPORTANT: Update the device path below with the actual device path!
# ⚠️  Run `lsblk` or `ls -l /dev/disk/by-id/` to find the correct device.
#
# Default assumption: /dev/nvme0n1 (most modern laptops use NVMe)
# Adjust if your laptop uses SATA (/dev/sda)

{ ... }:

{
  imports = [
    ../../config/nixos/disko/standard-uefi.nix
  ];

  # Override template parameters for Laptop
  disko.devices.disk.main = {
    # ⚠️  VERIFY THIS PATH BEFORE USING! ⚠️
    # Most modern laptops: /dev/nvme0n1
    # Older laptops with SATA: /dev/sda
    device = "/dev/nvme0n1";
  };
}
