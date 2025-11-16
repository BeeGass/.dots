# Disko disk configuration for Manifold - Dual-boot Windows/NixOS
#
# Hardware: AMD Ryzen 9950X3D, RTX 5090, 64GB DDR5 RAM
# Storage:
#   - /dev/nvme0n1 (2TB) - OS drive (Windows + NixOS dual-boot)
#   - /dev/nvme1n1 (2TB) - Data drive (pure XFS for ML)
#
# ⚠️  CRITICAL DUAL-BOOT WARNINGS ⚠️
#
# 1. DO NOT run disko's partitioning on a drive with Windows already installed!
# 2. This config is for MANUAL installation or FRESH install only
# 3. For dual-boot with existing Windows:
#    - Install Windows FIRST
#    - Shrink Windows partition using Windows Disk Management
#    - Manually partition the free space for NixOS
#    - Use this config as REFERENCE for fileSystems only
# 4. The ESP (/boot) will be SHARED with Windows
# 5. Windows updates may overwrite the bootloader - be prepared to repair
#
# ⚠️  VERIFY DEVICE PATHS BEFORE USING! ⚠️
# Run: lsblk
#      ls -l /dev/disk/by-id/
#
# Expected layout on /dev/nvme0n1 after Windows + manual partitioning:
#   Part 1: ESP (1GB) - Shared boot partition
#   Part 2: MSR (~16MB) - Windows reserved
#   Part 3: Windows (~1TB) - Windows C: drive
#   Part 4: Recovery (~500MB) - Windows recovery
#   Part 5: NixOS Root (~998GB) - Btrfs with subvolumes

{ ... }:

{
  imports = [
    ../../config/nixos/disko/manifold-dual-boot.nix
  ];

  # Override template parameters for Manifold
  # Device paths are defined in the template
  # OS drive: /dev/nvme0n1 (2TB - Windows + NixOS)
  # Data drive: /dev/nvme1n1 (2TB - pure XFS)
}
