{ config, pkgs, inputs, ... }:

{
  imports =
    [
      # Include the results of the hardware scan.
      ./hardware-configuration.nix
      inputs.home-manager.nixosModules.default
      ./main-user.nix
    ];

  # Bootloader configuration.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.efi.efiSysMountPoint = "/boot/efi";

  # Set the hostname.
  networking.hostName = "nixos"; 

  # Enable networking with NetworkManager.
  networking.networkmanager.enable = true;

  # Time zone configuration.
  time.timeZone = "America/New_York";

  # Locale settings.
  i18n.defaultLocale = "en_US.utf8";

  # X11 and Desktop Environment configuration.
  services.xserver = {
    enable = true;
    layout = "us";
    xkbVariant = "";
    displayManager.gdm.enable = true;
    desktopManager.gnome.enable = true;
  };

  # Enable CUPS for printing.
  services.printing.enable = true;

  # Configure sound with pipewire.
  sound.enable = true;
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  # User configuration.
  main-user = {
    enable = true;
    userName = "beegass"; # Ensure this matches the default or desired username in main-user.nix
    description = "BeeGass";
    initialPassword = "12345";
    packages = with pkgs; [
	firefox
    ];
  };

  home-manager = {
    extraSpecialArgs = { inherit inputs; };
    users = {
	"beegass" = import ./home.nix;
    };
  };

  # Allow unfree packages.
  nixpkgs.config.allowUnfree = true;

  # System-wide packages.
  environment.systemPackages = with pkgs; [
    #alacritty
    #zsh
    vim
    neovim
    wget
    #neofetch
  ];

  #Flakes
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  # System state version (do not change this unless you know what you're doing).
  system.stateVersion = "22.05";
}

