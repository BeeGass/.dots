# Base profile - Common configuration for ALL hosts
{ config, lib, pkgs, homelabLib, ... }:

{
  imports = [
    ../modules/services/tailscale.nix
    ../modules/services/monitoring.nix
    ../modules/services/container-runtime.nix
    ../modules/security/ssh-server.nix
    ../modules/security/secrets-management.nix
    ../modules/storage/system-updates.nix
  ];

  # Enable base services
  myHomelab = {
    services = {
      tailscale.enable = true;
      monitoring.enable = true;
      containers.enable = true;
    };
    security = {
      ssh.enable = true;
      secrets.enable = lib.mkDefault true;
    };
    storage.autoUpdate.enable = lib.mkDefault true;
  };

  # Common system settings
  time.timeZone = lib.mkDefault homelabLib.defaultTimezone;
  i18n = {
    defaultLocale = homelabLib.defaultLocale;
    extraLocaleSettings = homelabLib.mkLocaleSettings;
  };

  # Networking
  networking.networkmanager.enable = lib.mkDefault true;

  # Nix settings
  nix = {
    settings = {
      experimental-features = [ "nix-command" "flakes" ];
      trusted-users = [ "root" "@wheel" ];
    };
  };

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # Use latest stable LTS kernel
  boot.kernelPackages = lib.mkDefault pkgs.linuxPackages_6_12;

  # Common system packages
  environment.systemPackages = with pkgs; [
    vim
    neovim
    git
    curl
    wget
    tmux
    htop

    # Modern CLI tools
    ripgrep
    fd
    bat
    eza
    git-delta

    # GPG and security
    gnupg
    openssh
  ];

  # Common environment variables
  environment.sessionVariables = {
    EDITOR = "nvim";
    GPG_TTY = "$(tty)";
  };

  # Enable sound with pipewire
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };
  hardware.pulseaudio.enable = false;

  # Printing support
  services.printing.enable = lib.mkDefault true;

  # YubiKey support
  services.pcscd.enable = true;

  # Enable dconf for some applications
  programs.dconf.enable = true;

  # ZSH support (enabled system-wide)
  programs.zsh.enable = true;
}
