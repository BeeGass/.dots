{ lib, ... }:

{
  # Homelab host IP addresses
  homelabHosts = {
    manifold = "192.168.68.10";
    tensor = "192.168.68.11";
    jacobian = "192.168.68.30";
    hessian = "192.168.68.31";
  };

  # Helper to create monitoring endpoint strings
  mkMonitoringEndpoint = ip: port: "${ip}:${toString port}";

  # Helper to get all monitoring endpoints for a given port
  mkMonitoringEndpoints = port: hosts:
    map (host: "${host}:${toString port}") hosts;

  # Common timezone
  defaultTimezone = "America/New_York";

  # Common locale
  defaultLocale = "en_US.UTF-8";

  # Helper to create consistent locale settings
  mkLocaleSettings = {
    LC_ADDRESS = "en_US.UTF-8";
    LC_IDENTIFICATION = "en_US.UTF-8";
    LC_MEASUREMENT = "en_US.UTF-8";
    LC_MONETARY = "en_US.UTF-8";
    LC_NAME = "en_US.UTF-8";
    LC_NUMERIC = "en_US.UTF-8";
    LC_PAPER = "en_US.UTF-8";
    LC_TELEPHONE = "en_US.UTF-8";
    LC_TIME = "en_US.UTF-8";
  };
}
