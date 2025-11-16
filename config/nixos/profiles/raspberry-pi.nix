# Raspberry Pi profile - For ARM-based Raspberry Pi hosts
{ config, lib, pkgs, ... }:

{
  imports = [
    ./base.nix
    ../modules/hardware/power-management.nix
  ];

  # Enable balanced power management
  myHomelab.hardware.powerManagement = {
    enable = true;
    profile = "balanced";
  };

  # Raspberry Pi specific Nix settings
  nix.settings = {
    extra-substituters = [
      "https://nixos-raspberrypi.cachix.org"
      "https://cache.nixos.org/"
    ];
    extra-trusted-public-keys = [
      "nixos-raspberrypi.cachix.org-1:4iMO9LXa8BqhU+Rpg6LQKiGa2lsNh/j2oiYLNOQ5sPI="
      "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
    ];
  };

  # Enable emulation for cross-compilation
  boot.binfmt.emulatedSystems = [ "aarch64-linux" ];

  # Minimal GUI for headless operation (can be overridden)
  services.xserver.enable = lib.mkDefault false;

  # Lower zram percentage for limited RAM
  myHomelab.hardware.powerManagement.zramPercentage = lib.mkDefault 30;
}
