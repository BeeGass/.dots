{ config, pkgs, ... }:

{
  imports = [
    #../../config/home-manager/alacritty.nix
    #../../config/home-manager/eww.nix
    ../../config/home-manager/git.nix
    ../../config/home-manager/github.nix
    ../../config/home-manager/gpg/gpg-agent.nix
    ../../config/home-manager/gpg/gpg.nix
    #../../config/home-manager/hyprland.nix
    ../../config/home-manager/i3.nix
    # ../../config/home-manager/keychain/keychain.nix
    ../../config/home-manager/kitty.nix
    ../../config/home-manager/neovim.nix
    ../../config/home-manager/polybar.nix
    ../../config/home-manager/picom.nix
    ../../config/home-manager/rofi.nix
    # ../../config/home-manager/ssh/ssh-agent.nix
    ../../config/home-manager/ssh/ssh.nix
    ../../config/home-manager/tmux.nix
    #../../config/home-manager/waybar.nix
    ../../config/home-manager/zsh.nix
  ];

  # Apply the unfreePredicate configuration here
  # nixpkgs.config = unfreePredicate;

  # Home Manager needs a bit of information about you and the paths it should
  # manage.
  home.username = "beegass";
  home.homeDirectory = "/home/beegass";
  home.sessionVariables = {
    GPG_TTY = "$(tty)";
    SSH_AUTH_SOCK = "$(gpgconf --list-dirs agent-ssh-socket)";
    KEYID = "0xA34200D828A7BB26";
    S_KEYID = "0xACC3640C138D96A2";
    E_KEYID = "0x21691AE75B0463CC";
    A_KEYID = "0x27D667E55F655FD2";
  };

  # This value determines the Home Manager release that your configuration is
  # compatible with. This helps avoid breakage when a new Home Manager release
  # introduces backwards incompatible changes.
  #
  # You should not change this value, even if you update Home Manager. If you do
  # want to update the value, then make sure to first check the Home Manager
  # release notes.
  home.stateVersion = "23.11"; # Please read the comment before changing.

  # The home.packages option allows you to install Nix packages into your
  # environment.
  home.packages = with pkgs; [
    # Free Section
    bat
    cbonsai
    font-awesome
    neofetch
    maim
    nix-prefetch-github
    nix-output-monitor
    #nom
    rmview
    source-code-pro
    telegram-desktop
    terminus-nerdfont
    tree
    (pkgs.callPackage ../../config/home-manager/fonts/google-sans-mono.nix {})
    (pkgs.callPackage ../../config/home-manager/fonts/google-sans.nix {})
    xclip

    # Scripts
    (pkgs.callPackage ../../config/home-manager/scripts/getbranch.nix {})
    (pkgs.callPackage ../../config/home-manager/scripts/gpg-ssh-key.nix {})

    #Unfree Section
    discord
    material-icons
    obsidian
    spotify
    vscode-fhs


    # # Adds the 'hello' command to your environment. It prints a friendly
    # # "Hello, world!" when run.
    # pkgs.hello

    # # It is sometimes useful to fine-tune packages, for example, by applying
    # # overrides. You can do that directly here, just don't forget the
    # # parentheses. Maybe you want to install Nerd Fonts with a limited number of
    # # fonts?
    # (pkgs.nerdfonts.override { fonts = [ "FantasqueSansMono" ]; })

    # # You can also create simple shell scripts directly inside your
    # # configuration. For example, this adds a command 'my-hello' to your
    # # environment:
    # (pkgs.writeShellScriptBin "my-hello" ''
    #   echo "Hello, ${config.home.username}!"
    # '')
  ];

  # Home Manager is pretty good at managing dotfiles. The primary way to manage
  # plain files is through 'home.file'.
  home.file = {
    # # Building this configuration will create a copy of 'dotfiles/screenrc' in
    # # the Nix store. Activating the configuration will then make '~/.screenrc' a
    # # symlink to the Nix store copy.
    # ".screenrc".source = dotfiles/screenrc;

    # # You can also set the file content immediately.
    # ".gradle/gradle.properties".text = ''
    #   org.gradle.console=verbose
    #   org.gradle.daemon.idletimeout=3600000
    # '';
  };

  # Home Manager can also manage your environment variables through
  # 'home.sessionVariables'. If you don't want to manage your shell through Home
  # Manager then you have to manually source 'hm-session-vars.sh' located at
  # either
  #
  #  ~/.nix-profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  ~/.local/state/nix/profiles/profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  /etc/profiles/per-user/beegass/etc/profile.d/hm-session-vars.sh
  #
  home.sessionVariables = {
    SHELL = "zsh";
    EDITOR = "nvim";
    TERMINAL = "kitty";
  };

  fonts.fontconfig.enable = true;

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
