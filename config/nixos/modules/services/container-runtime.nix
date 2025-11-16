# Container module using Podman
{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.myHomelab.services.containers;
in
{
  options.myHomelab.services.containers = {
    enable = mkEnableOption "Podman container runtime";

    enableNvidiaSupport = mkOption {
      type = types.bool;
      default = false;
      description = "Enable NVIDIA GPU support in containers";
    };

    storageDriver = mkOption {
      type = types.str;
      default = "overlay";
      description = "Container storage driver";
    };
  };

  config = mkIf cfg.enable {
    virtualisation.podman = {
      enable = true;
      dockerCompat = true;
      dockerSocket.enable = true;
      defaultNetwork.settings.dns_enabled = true;
      enableNvidia = cfg.enableNvidiaSupport;
    };

    virtualisation.containers.storage.settings = {
      storage = {
        driver = cfg.storageDriver;
        graphroot = "/var/lib/containers/storage";
        runroot = "/run/containers/storage";
      };
    };

    virtualisation.containers.registries.search = [
      "docker.io"
      "quay.io"
      "ghcr.io"
    ];

    environment.systemPackages = with pkgs; [
      podman-compose
      podman-tui
      dive
      skopeo
      buildah
    ];
  };
}
