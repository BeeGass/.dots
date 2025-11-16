# Power management module for laptops and low-power devices
{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.myHomelab.hardware.powerManagement;
in
{
  options.myHomelab.hardware.powerManagement = {
    enable = mkEnableOption "power management optimizations";

    profile = mkOption {
      type = types.enum [ "balanced" "powersave" "performance" ];
      default = "balanced";
      description = "Power management profile";
    };

    enableTLP = mkOption {
      type = types.bool;
      default = true;
      description = "Enable TLP for advanced power management";
    };

    zramPercentage = mkOption {
      type = types.int;
      default = 50;
      description = "Percentage of RAM to use for zram compressed swap";
    };
  };

  config = mkIf cfg.enable {
    powerManagement.cpuFreqGovernor = mkDefault cfg.profile;

    services.tlp = mkIf cfg.enableTLP {
      enable = true;
      settings = {
        CPU_SCALING_GOVERNOR_ON_AC = if cfg.profile == "performance" then "performance" else "ondemand";
        CPU_SCALING_GOVERNOR_ON_BAT = if cfg.profile == "powersave" then "powersave" else "ondemand";

        CPU_BOOST_ON_AC = if cfg.profile == "performance" then 1 else 0;
        CPU_BOOST_ON_BAT = 0;

        CPU_MIN_PERF_ON_AC = 0;
        CPU_MAX_PERF_ON_AC = 100;
        CPU_MIN_PERF_ON_BAT = 0;
        CPU_MAX_PERF_ON_BAT = if cfg.profile == "powersave" then 30 else 60;

        DISK_IDLE_SECS_ON_AC = 0;
        DISK_IDLE_SECS_ON_BAT = 2;

        WIFI_PWR_ON_AC = "off";
        WIFI_PWR_ON_BAT = "on";

        USB_AUTOSUSPEND = 1;
        USB_BLACKLIST_PHONE = 1;
      };
    };

    boot.kernel.sysctl = {
      "vm.swappiness" = if cfg.profile == "powersave" then 100 else 60;
      "vm.vfs_cache_pressure" = 100;
      "fs.inotify.max_user_watches" = 524288;
    };

    services.thermald.enable = mkDefault true;

    zramSwap = {
      enable = true;
      algorithm = "zstd";
      memoryPercent = cfg.zramPercentage;
    };

    environment.systemPackages = with pkgs; [
      htop
      powertop
      acpi
    ];
  };
}
