# Disko disk configuration for Tensor - Multi-drive ML workstation
#
# Hardware: AMD Ryzen 9 3900X, RTX 3080, 32GB RAM
# Storage:
#   - /dev/nvme0n1 (1TB) - Mixed OS/Data drive
#   - /dev/nvme1n1 (2TB) - Pure data drive
#   - /dev/nvme2n1 (2TB) - Pure data drive
#
# ⚠️  IMPORTANT: Verify device paths before using!
# ⚠️  Run: lsblk
# ⚠️       ls -l /dev/disk/by-id/
# ⚠️  Using the wrong device will result in data loss!
#
# Layout:
#   /dev/nvme0n1:
#     Part 1: ESP (1GB) - Boot partition
#     Part 2: Root (500GB) - Btrfs with subvolumes (@, @home, @nix, @log)
#     Part 3: Data (~499GB) - XFS mounted at /data
#
#   /dev/nvme1n1:
#     Part 1: Data (2TB) - XFS mounted at /data2
#
#   /dev/nvme2n1:
#     Part 1: Data (2TB) - XFS mounted at /data3
#
# Total data capacity: ~4.5TB across /data, /data2, /data3

{ ... }:

{
  imports = [
    ../../config/nixos/disko/tensor-multi-drive.nix
  ];

  # Device paths are defined in the template
  # All three NVMe drives will be partitioned and formatted
}
