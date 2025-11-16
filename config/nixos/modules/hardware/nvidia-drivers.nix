# NVIDIA GPU module with ML stack
{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.myHomelab.hardware.nvidia;
in
{
  options.myHomelab.hardware.nvidia = {
    enable = mkEnableOption "NVIDIA GPU drivers";

    enableMLStack = mkOption {
      type = types.bool;
      default = false;
      description = "Enable CUDA toolkit and ML-related packages";
    };

    gpuModel = mkOption {
      type = types.str;
      default = "Unknown";
      example = "RTX 3080";
      description = "GPU model for documentation purposes";
    };

    useOpenDrivers = mkOption {
      type = types.bool;
      default = false;
      description = "Use open-source NVIDIA drivers (not recommended for RTX cards)";
    };
  };

  config = mkIf cfg.enable {
    services.xserver.videoDrivers = [ "nvidia" ];

    hardware.nvidia = {
      modesetting.enable = true;
      powerManagement.enable = true;
      powerManagement.finegrained = false;
      open = cfg.useOpenDrivers;
      nvidiaSettings = true;
      package = config.boot.kernelPackages.nvidiaPackages.stable;
    };

    hardware.graphics = {
      enable = true;
      enable32Bit = true;
    };

    environment.systemPackages = with pkgs; [
      nvtopPackages.nvidia
      nvidia-system-monitor-qt
    ] ++ optionals cfg.enableMLStack [
      cudatoolkit
      cudnn
    ];

    environment.variables = mkIf cfg.enableMLStack {
      CUDA_PATH = "${pkgs.cudatoolkit}";
      EXTRA_LDFLAGS = "-L${pkgs.cudatoolkit}/lib";
      EXTRA_CCFLAGS = "-I${pkgs.cudatoolkit}/include";
    };

    environment.sessionVariables = mkIf cfg.enableMLStack {
      LD_LIBRARY_PATH = mkDefault (lib.makeLibraryPath [
        pkgs.cudatoolkit
        pkgs.cudnn
      ]);
    };

    systemd.services.nvidia-persistenced = {
      description = "NVIDIA Persistence Daemon";
      wantedBy = [ "multi-user.target" ];
      serviceConfig = {
        Type = "forking";
        ExecStart = "${config.boot.kernelPackages.nvidiaPackages.stable}/bin/nvidia-persistenced --user=nvidia-persistenced";
        ExecStopPost = "${pkgs.coreutils}/bin/rm -rf /var/run/nvidia-persistenced";
      };
    };

    users.users.nvidia-persistenced = {
      isSystemUser = true;
      group = "nvidia-persistenced";
    };
    users.groups.nvidia-persistenced = {};
  };
}
