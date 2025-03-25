{ config, pkgs, inputs, ... }:

{
  imports =
    [
      # Include the results of the hardware scan.
      ./hardware-configuration.nix

      # Allow creation of arbitrary user
      ./main-user.nix

      # import home manager
      inputs.home-manager.nixosModules.default
    ];

  # Bootloader configuration.
  boot = {
    loader = {
      systemd-boot = {
        enable = true;
        configurationLimit = 10;  # Limits number of generations kept
      };
      efi = {
        canTouchEfiVariables = true;
        efiSysMountPoint = "/boot/efi";  # This may differ depending on your VM setup
      };
      # grub = {
      #   enable = true;
      #   version = 2;
      #   device = "/dev/sda";
      #   useOSProber = true;
      # };
    };
  };

  # Set the hostname.
  networking.hostName = "beegass-vm";

  # Enable networking with NetworkManager.
  networking.networkmanager.enable = true;

  # Time zone configuration.
  time.timeZone = "America/New_York";

  # Locale settings.
  i18n.defaultLocale = "en_US.UTF-8";
  i18n.extraLocaleSettings = {
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

  # X11 and Desktop Environment configuration.
  services.xserver = {
    enable = true;
    xkb = {
      layout = "us";
      variant = "";
    };
    # You can choose which desktop environment to use
    # displayManager.lightdm.enable = true;

    # Either use XFCE or i3 based on your preference
    # desktopManager.xfce.enable = true;
    windowManager = {
      i3 = {
        enable = true;
      };
    };
  };

  # Enable CUPS for printing.
  services.printing.enable = true;

  # Enable PCSC-Lite for YubiKey
  services.pcscd.enable = true;

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
    userName = "beegass";
    description = "beegass";
    initialPassword = "12345";
    packages = with pkgs; [
       zsh
       wget
       curl
       git
       tmux
       openssh
       vim
       neovim
       htop
    ];
    openssh.authorizedKeys.keys = [
	"ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQDBfKtG2GULp83ZdTECg0rdSS2msrKgjNMCPdrROM3Weoj+2BhEKv5wsAoMIIl7cGCXjX+b8Gm8BEpkemJBjlsGeGZwtllBzF9s2LiYvdnIUj7We4+1GjFLcjOHnbdDZ7y88MdVd+ZcMRpw/zZAS0Wio3FBr85sNIlI6Wq7qq4MjbQPdD3cxj1oXcRF55hZQ3L1JedQXdZSZGzmKh/f7WGPy7JVYJXerHbwef1+q2VZ6PObomJMyAe50JAN8lFhsUpRaxIDyLUCmn+WH7oFF/q3KXNOVwzE1G8X2McTKMM6OE9D4bCE3WkVS13vnJLiM13dy9uzsoNF7qbMcpF9C45mtcuT3hnA8EwkH5cW8t3nAz1j9BhrDY+MPfnlLbZZcglfuTd55t+QuWgVomsUuy9ePqH83pgsParepp3GZIcjMUAu6Yf5pj6jFKPSUvwwsF+ytKdxmTRqscttSAkvJa45xt2s+wO9vWJpU+D9u6hKhCXVRcJrq1rbeXNfRnQjMuz/X67SXDBTT2GkBO1rvPaGdblgZ4Qnt4WD7FS7cXm9wMgVlw9cc/yGYEAYDRhrG0Mxy9qy7MLkifI5vyUtGghpmN2QCn0Na0Vy1MoQuImpCsNqCtMe8TbcFCOyn8iZ+QeWecriyzyBO5YBwJjp/+Xg8daAFcGzTuNj5e4H34rC7w== cardno:15_123_193"
	"ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQDBfKtG2GULp83ZdTECg0rdSS2msrKgjNMCPdrROM3Weoj+2BhEKv5wsAoMIIl7cGCXjX+b8Gm8BEpkemJBjlsGeGZwtllBzF9s2LiYvdnIUj7We4+1GjFLcjOHnbdDZ7y88MdVd+ZcMRpw/zZAS0Wio3FBr85sNIlI6Wq7qq4MjbQPdD3cxj1oXcRF55hZQ3L1JedQXdZSZGzmKh/f7WGPy7JVYJXerHbwef1+q2VZ6PObomJMyAe50JAN8lFhsUpRaxIDyLUCmn+WH7oFF/q3KXNOVwzE1G8X2McTKMM6OE9D4bCE3WkVS13vnJLiM13dy9uzsoNF7qbMcpF9C45mtcuT3hnA8EwkH5cW8t3nAz1j9BhrDY+MPfnlLbZZcglfuTd55t+QuWgVomsUuy9ePqH83pgsParepp3GZIcjMUAu6Yf5pj6jFKPSUvwwsF+ytKdxmTRqscttSAkvJa45xt2s+wO9vWJpU+D9u6hKhCXVRcJrq1rbeXNfRnQjMuz/X67SXDBTT2GkBO1rvPaGdblgZ4Qnt4WD7FS7cXm9wMgVlw9cc/yGYEAYDRhrG0Mxy9qy7MLkifI5vyUtGghpmN2QCn0Na0Vy1MoQuImpCsNqCtMe8TbcFCOyn8iZ+QeWecriyzyBO5YBwJjp/+Xg8daAFcGzTuNj5e4H34rC7w== openpgp:0x5F655FD2 beegass-gpg-key"
    ];
  };

  home-manager = {
    extraSpecialArgs = { inherit inputs; };
    users = {
	"beegass" = import ./home.nix;
    };
    useGlobalPkgs = true;
  };

  programs = {
    zsh = {
      enable = true; # zsh needs to be enabled system-wide before being enabled at a user level
    };
    gnupg = {
      agent = {
        enable = true;
        enableSSHSupport = true;
      };
    };
    dconf = {
      enable = true;
    };
  };
  users.users.beegass.shell = pkgs.zsh; # enable at a user level

  # gnome performs its own ssh-agent stuff that prevents gpg-agent and ssh-agent from interacting
  #nixpkgs.overlays = [
  #  (import ../../config/overlays/gnome-overlay.nix)
  #];

  # Allow unfree packages.
  nixpkgs.config.allowUnfree = true;

  # System-wide packages.
  environment.systemPackages = with pkgs; [
    pinentry-gtk2
    vim
    wget
    curl
    git
    tmux
    openssh
    neovim
    htop
    maim
  ];

  environment.sessionVariables = {
    SHELL = "zsh";
    EDITOR = "nvim";
    TERMINAL = "kitty";
    GPG_TTY = "$(tty)";
  };

  # Flakes
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  # SSH Server:
  services.openssh = {
    enable = true;
    ports = [7569];
    settings.PermitRootLogin = "yes";
    settings.PasswordAuthentication = false;
  };

  # Nvidia
  #services.xserver.videoDrivers = ["nvidia"]

  fonts.fontDir.enable = true;
  fonts.packages = with pkgs; [
    font-awesome
    source-code-pro
    terminus-nerdfont
    (pkgs.callPackage ../../config/home-manager/fonts/google-sans-mono.nix {})
    (pkgs.callPackage ../../config/home-manager/fonts/google-sans.nix {})
  ];

  #Firefox
  programs.firefox.enable = true;

  # System state version (do not change this unless you know what you're doing).
  system.stateVersion = "24.11";
}
