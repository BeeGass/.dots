# Workstation profile - For desktop/laptop machines with GUI
{ config, lib, pkgs, ... }:

{
  imports = [
    ./base.nix
    ../modules/storage/btrfs-snapshots.nix
    ../modules/hardware/power-management.nix
  ];

  # Enable btrfs snapshots
  myHomelab.storage.btrfsSnapshots.enable = lib.mkDefault true;

  # X11 and window manager
  services.xserver = {
    enable = true;
    xkb = {
      layout = "us";
      variant = "";
    };

    # i3 window manager
    windowManager.i3.enable = true;
  };

  # Workstation-specific packages
  environment.systemPackages = with pkgs; [
    # Terminal emulator
    kitty

    # Screenshot tools
    maim
    xclip

    # Fonts
    font-awesome
    source-code-pro
    oh-my-posh
  ];

  # Session variables for GUI
  environment.sessionVariables = {
    SHELL = "zsh";
    TERMINAL = "kitty";
    SSH_AUTH_SOCK = "$(gpgconf --list-dirs agent-ssh-socket)";
  };

  # Font configuration
  fonts = {
    fontDir.enable = true;
    packages = with pkgs; [
      font-awesome
      source-code-pro
      nerd-fonts.terminess-ttf
    ];
  };
}
