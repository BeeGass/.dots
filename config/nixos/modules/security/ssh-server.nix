# SSH security module
{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.myHomelab.security.ssh;
in
{
  options.myHomelab.security.ssh = {
    enable = mkEnableOption "hardened SSH server";

    profile = mkOption {
      type = types.enum [ "homelab" "external" ];
      default = "homelab";
      description = "SSH security profile: homelab (YubiKey + password) or external (YubiKey only)";
    };

    port = mkOption {
      type = types.int;
      default = 22;
      description = "SSH port";
    };

    allowedUsers = mkOption {
      type = types.listOf types.str;
      default = [ "beegass" ];
      description = "Users allowed to SSH";
    };
  };

  config = mkIf cfg.enable {
    services.openssh = {
      enable = true;
      ports = [ cfg.port ];

      settings = {
        PermitRootLogin = "no";
        PasswordAuthentication = cfg.profile == "homelab";
        PubkeyAuthentication = true;
        KbdInteractiveAuthentication = cfg.profile == "homelab";
        AllowUsers = cfg.allowedUsers;

        # Security hardening
        X11Forwarding = false;
        PermitEmptyPasswords = false;
        ChallengeResponseAuthentication = false;
        UsePAM = true;

        # Performance and connection settings
        ClientAliveInterval = 300;
        ClientAliveCountMax = 2;
        MaxAuthTries = 3;
        MaxSessions = 10;
      };

      hostKeys = [
        {
          path = "/etc/ssh/ssh_host_ed25519_key";
          type = "ed25519";
        }
        {
          path = "/etc/ssh/ssh_host_rsa_key";
          type = "rsa";
          bits = 4096;
        }
      ];
    };

    # Enable PCSC-Lite for YubiKey support
    services.pcscd.enable = true;

    # Firewall configuration
    networking.firewall.allowedTCPPorts = [ cfg.port ];

    # Fail2ban for brute force protection (only for external profile)
    services.fail2ban = mkIf (cfg.profile == "external") {
      enable = true;
      maxretry = 3;
      ignoreIP = [
        "127.0.0.1/8"
        "192.168.68.0/24"  # Homelab network
      ];
    };
  };
}
