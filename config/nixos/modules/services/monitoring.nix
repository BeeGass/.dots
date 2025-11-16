# Monitoring module (Prometheus + Grafana + Exporters)
{ config, lib, pkgs, homelabLib, ... }:

with lib;

let
  cfg = config.myHomelab.services.monitoring;
in
{
  options.myHomelab.services.monitoring = {
    enable = mkEnableOption "monitoring with Prometheus exporters";

    role = mkOption {
      type = types.enum [ "server" "worker" ];
      default = "worker";
      description = "Monitoring role: server (Prometheus+Grafana) or worker (exporters only)";
    };

    exportGPUMetrics = mkOption {
      type = types.bool;
      default = false;
      description = "Enable NVIDIA GPU metrics exporter";
    };

    prometheusRetention = mkOption {
      type = types.str;
      default = "30d";
      description = "Prometheus metrics retention period";
    };

    scrapeTargets = mkOption {
      type = types.attrs;
      default = homelabLib.homelabHosts;
      description = "Hosts to scrape metrics from";
    };
  };

  config = mkIf cfg.enable (mkMerge [
    # Common configuration for all monitoring nodes
    {
      services.prometheus.exporters.node = {
        enable = true;
        enabledCollectors = [
          "cpu" "diskstats" "filesystem" "loadavg"
          "meminfo" "netdev" "stat" "time" "uname" "systemd"
        ];
        port = 9100;
        openFirewall = true;
      };

      environment.systemPackages = with pkgs; [
        prometheus-node-exporter
      ];
    }

    # GPU metrics exporter
    (mkIf cfg.exportGPUMetrics {
      services.prometheus.exporters.nvidia-gpu = {
        enable = true;
        port = 9835;
        openFirewall = true;
      };

      environment.systemPackages = with pkgs; [
        nvtopPackages.nvidia
      ];
    })

    # Prometheus + Grafana server
    (mkIf (cfg.role == "server") {
      services.prometheus = {
        enable = true;
        port = 9090;
        retentionTime = cfg.prometheusRetention;

        scrapeConfigs = [
          {
            job_name = "homelab-nodes";
            static_configs = [{
              targets = map (host: "${host}:9100") (attrValues cfg.scrapeTargets);
            }];
          }
          {
            job_name = "gpu-nodes";
            static_configs = [{
              targets = [
                "${cfg.scrapeTargets.manifold}:9835"
                "${cfg.scrapeTargets.tensor}:9835"
              ];
            }];
          }
          {
            job_name = "prometheus";
            static_configs = [{
              targets = [ "localhost:9090" ];
            }];
          }
        ];
      };

      services.grafana = {
        enable = true;
        settings = {
          server = {
            http_addr = "0.0.0.0";
            http_port = 3000;
            domain = "grafana.local";
          };
          analytics.reporting_enabled = false;
          security = {
            admin_user = "admin";
            admin_password = "$__file{/run/secrets/grafana-admin-password}";
          };
        };

        provision = {
          enable = true;
          datasources.settings.datasources = [{
            name = "Prometheus";
            type = "prometheus";
            url = "http://localhost:9090";
            isDefault = true;
          }];
        };
      };

      networking.firewall.allowedTCPPorts = [ 9090 3000 ];

      environment.systemPackages = with pkgs; [
        prometheus
        grafana
      ];

      systemd.tmpfiles.rules = [
        "d /run/secrets 0755 root root -"
        "f /run/secrets/grafana-admin-password 0600 grafana grafana - admin"
      ];
    })
  ]);
}
