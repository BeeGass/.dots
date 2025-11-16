# Performance tuning module for ML workstations
{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.myHomelab.hardware.performance;
in
{
  options.myHomelab.hardware.performance = {
    enable = mkEnableOption "performance optimizations for ML workstations";

    hugePagesGB = mkOption {
      type = types.int;
      default = 16;
      description = "Gigabytes to allocate for huge pages (2MB pages)";
    };

    zramPercentage = mkOption {
      type = types.int;
      default = 25;
      description = "Percentage of RAM to use for zram compressed swap";
    };
  };

  config = mkIf cfg.enable {
    powerManagement.cpuFreqGovernor = "performance";

    boot.kernel.sysctl = {
      # Virtual memory tuning
      "vm.swappiness" = 10;
      "vm.vfs_cache_pressure" = 50;
      "vm.dirty_ratio" = 10;
      "vm.dirty_background_ratio" = 5;

      # File system limits
      "fs.inotify.max_user_watches" = 524288;
      "fs.file-max" = 2097152;
      "fs.nr_open" = 2097152;

      # Network performance
      "net.core.rmem_max" = 134217728;
      "net.core.wmem_max" = 134217728;
      "net.ipv4.tcp_rmem" = "4096 87380 67108864";
      "net.ipv4.tcp_wmem" = "4096 65536 67108864";
      "net.core.netdev_max_backlog" = 5000;
      "net.netfilter.nf_conntrack_max" = 1048576;
    };

    boot.kernelParams = [
      "transparent_hugepage=madvise"
      "hugepagesz=2M"
      "hugepages=${toString (cfg.hugePagesGB * 512)}"
    ];

    services.udev.extraRules = ''
      ACTION=="add|change", KERNEL=="nvme[0-9]n[0-9]", ATTR{queue/scheduler}="none"
      ACTION=="add|change", KERNEL=="nvme[0-9]n[0-9]", ATTR{queue/read_ahead_kb}="1024"
    '';

    zramSwap = {
      enable = true;
      algorithm = "zstd";
      memoryPercent = cfg.zramPercentage;
    };

    environment.systemPackages = with pkgs; [
      htop
      iotop
      powertop
      stress-ng
      sysbench
      pciutils
      usbutils
    ];
  };
}
