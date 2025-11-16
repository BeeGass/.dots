# ML Workstation profile - For machine learning workstations with NVIDIA GPUs
{ config, lib, pkgs, ... }:

{
  imports = [
    ./workstation.nix
    ../modules/hardware/nvidia-drivers.nix
    ../modules/hardware/performance-tuning.nix
  ];

  # Enable NVIDIA with ML stack
  myHomelab.hardware = {
    nvidia = {
      enable = true;
      enableMLStack = true;
    };
    performance.enable = true;
  };

  # Enable GPU monitoring
  myHomelab.services.monitoring.exportGPUMetrics = true;

  # Enable NVIDIA support in containers
  myHomelab.services.containers.enableNvidiaSupport = true;

  # ML development packages
  environment.systemPackages = with pkgs; [
    python3
    uv  # Fast Python package manager

    # Development tools
    python3Packages.ipython
  ];

  # Larger huge pages allocation for ML workloads
  myHomelab.hardware.performance.hugePagesGB = lib.mkDefault 16;
}
