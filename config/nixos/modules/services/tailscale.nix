# Tailscale VPN module with proper options
{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.myHomelab.services.tailscale;
in
{
  options.myHomelab.services.tailscale = {
    enable = mkEnableOption "Tailscale VPN";

    advertiseRoutes = mkOption {
      type = types.listOf types.str;
      default = [];
      example = [ "192.168.68.0/24" ];
      description = "Subnets to advertise to the Tailscale network";
    };

    enableExitNode = mkOption {
      type = types.bool;
      default = false;
      description = "Enable this node as an exit node";
    };
  };

  config = mkIf cfg.enable {
    services.tailscale = {
      enable = true;
      useRoutingFeatures =
        if (cfg.advertiseRoutes != [] || cfg.enableExitNode)
        then "both"
        else "client";
    };

    networking.firewall = {
      allowedUDPPorts = [ config.services.tailscale.port ];
      checkReversePath = "loose";
      trustedInterfaces = [ "tailscale0" ];
    };

    boot.kernel.sysctl = mkIf (cfg.advertiseRoutes != [] || cfg.enableExitNode) {
      "net.ipv4.ip_forward" = 1;
      "net.ipv6.conf.all.forwarding" = 1;
    };

    environment.systemPackages = with pkgs; [
      tailscale
    ];

    # Persist Tailscale state if impermanence is enabled
    environment.persistence."/nix/persist" = mkIf (builtins.hasAttr "persistence" config.environment) {
      directories = [
        "/var/lib/tailscale"
      ];
    };
  };
}
