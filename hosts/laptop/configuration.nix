# Laptop Configuration
{ config, pkgs, inputs, ... }:

{
  imports = [
    # Disko declarative disk partitioning
    inputs.disko.nixosModules.disko
    ./disko-config.nix

    # Hardware configuration
    ./hardware-configuration.nix

    # Workstation profile (includes base, btrfs snapshots, X11, i3, power management, etc.)
    ../../config/nixos/profiles/workstation.nix

    # User configuration
    ./main-user.nix
  ];

  # Hostname
  networking.hostName = "laptop";

  # Monitoring role
  myHomelab.services.monitoring.role = "worker";

  # Use latest stable LTS kernel (6.12 as of Nov 2025)
  boot.kernelPackages = pkgs.linuxPackages_6_12;

  # Enable NetworkManager (in addition to base network settings)
  networking.networkmanager.enable = true;

  # Bootloader (uncomment after hardware configuration is generated)
  # boot.loader.systemd-boot.enable = true;
  # boot.loader.efi.canTouchEfiVariables = true;

  # User management via home-manager
  home-manager.users.beegass = import ./home.nix;

  # Main user configuration
  main-user = {
    enable = true;
    userName = "beegass";
    description = "beegass";
    initialPassword = "12345";
    packages = with pkgs; [
      zsh wget curl git xclip tmux openssh vim neovim htop
    ];
    openssh.authorizedKeys.keys = [
      "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQDBfKtG2GULp83ZdTECg0rdSS2msrKgjNMCPdrROM3Weoj+2BhEKv5wsAoMIIl7cGCXjX+b8Gm8BEpkemJBjlsGeGZwtllBzF9s2LiYvdnIUj7We4+1GjFLcjOHnbdDZ7y88MdVd+ZcMRpw/zZAS0Wio3FBr85sNIlI6Wq7qq4MjbQPdD3cxj1oXcRF55hZQ3L1JedQXdZSZGzmKh/f7WGPy7JVYJXerHbwef1+q2VZ6PObomJMyAe50JAN8lFhsUpRaxIDyLUCmn+WH7oFF/q3KXNOVwzE1G8X2McTKMM6OE9D4bCE3WkVS13vnJLiM13dy9uzsoNF7qbMcpF9C45mtcuT3hnA8EwkH5cW8t3nAz1j9BhrDY+MPfnlLbZZcglfuTd55t+QuWgVomsUuy9ePqH83pgsParepp3GZIcjMUAu6Yf5pj6jFKPSUvwwsF+ytKdxmTRqscttSAkvJa45xt2s+wO9vWJpU+D9u6hKhCXVRcJrq1rbeXNfRnQjMuz/X67SXDBTT2GkBO1rvPaGdblgZ4Qnt4WD7FS7cXm9wMgVlw9cc/yGYEAYDRhrG0Mxy9qy7MLkifI5vyUtGghpmN2QCn0Na0Vy1MoQuImpCsNqCtMe8TbcFCOyn8iZ+QeWecriyzyBO5YBwJjp/+Xg8daAFcGzTuNj5e4H34rC7w== cardno:15_123_193"
      "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQDBfKtG2GULp83ZdTECg0rdSS2msrKgjNMCPdrROM3Weoj+2BhEKv5wsAoMIIl7cGCXjX+b8Gm8BEpkemJBjlsGeGZwtllBzF9s2LiYvdnIUj7We4+1GjFLcjOHnbdDZ7y88MdVd+ZcMRpw/zZAS0Wio3FBr85sNIlI6Wq7qq4MjbQPdD3cxj1oXcRF55hZQ3L1JedQXdZSZGzmKh/f7WGPy7JVYJXerHbwef1+q2VZ6PObomJMyAe50JAN8lFhsUpRaxIDyLUCmn+WH7oFF/q3KXNOVwzE1G8X2McTKMM6OE9D4bCE3WkVS13vnJLiM13dy9uzsoNF7qbMcpF9C45mtcuT3hnA8EwkH5cW8t3nAz1j9BhrDY+MPfnlLbZZcglfuTd55t+QuWgVomsUuy9ePqH83pgsParepp3GZIcjMUAu6Yf5pj6jFKPSUvwwsF+ytKdxmTRqscttSAkvJa45xt2s+wO9vWJpU+D9u6hKhCXVRcJrq1rbeXNfRnQjMuz/X67SXDBTT2GkBO1rvPaGdblgZ4Qnt4WD7FS7cXm9wMgVlw9cc/yGYEAYDRhrG0Mxy9qy7MLkifI5vyUtGghpmN2QCn0Na0Vy1MoQuImpCsNqCtMe8TbcFCOyn8iZ+QeWecriyzyBO5YBwJjp/+Xg8daAFcGzTuNj5e4H34rC7w== openpgp:0x5F655FD2 beegass-gpg-key"
    ];
  };

  users.users.beegass.shell = pkgs.zsh;

  # Additional fonts
  fonts.packages = with pkgs; [
    (pkgs.callPackage ../../config/home-manager/fonts/google-sans-mono.nix {})
    (pkgs.callPackage ../../config/home-manager/fonts/google-sans.nix {})
  ];

  # System state version
  system.stateVersion = "24.11";
}
