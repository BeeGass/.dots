# Base Home Manager profile - Common configuration for all users
{ config, pkgs, ... }:

{
  imports = [
    #../alacritty.nix
    #../eww.nix
    ../git.nix
    ../github.nix
    ../gpg/gpg-agent.nix
    ../gpg/gpg.nix
    #../hyprland.nix
    ../i3.nix
    # ../keychain/keychain.nix
    ../kitty.nix
    ../neovim.nix
    ../oh-my-posh.nix
    ../polybar.nix
    ../picom.nix
    ../rofi.nix
    # ../ssh/ssh-agent.nix
    ../ssh/ssh.nix
    ../tmux.nix
    #../waybar.nix
    ../zsh.nix
  ];

  # Home Manager needs a bit of information about you and the paths it should
  # manage.
  home.username = "beegass";
  home.homeDirectory = "/home/beegass";
  home.sessionVariables = {
    GPG_TTY = "$(tty)";
    SSH_AUTH_SOCK = "$(gpgconf --list-dirs agent-ssh-socket)";
    KEYID = "0xACC3640C138D96A2";  # Updated to match git signing key
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
  home.packages = with pkgs;
  let
    scripts = pkgs.callPackage ../scripts/default.nix {};
  in [
    # Free Section
    bat
    cbonsai
    xclip
    font-awesome
    neofetch
    maim
    nix-prefetch-github
    nix-output-monitor
    #nom
    rmview
    source-code-pro
    telegram-desktop
    nerd-fonts.terminess-ttf
    tree
    (pkgs.callPackage ../fonts/google-sans-mono.nix {})
    (pkgs.callPackage ../fonts/google-sans.nix {})

    # Shell tools
    eza               # Modern ls replacement
    lsd               # Fallback ls replacement
    ripgrep           # Fast grep replacement
    fd                # Fast find replacement
    git-delta         # Better git diffs
    wl-clipboard      # Wayland clipboard
    yubikey-manager   # YubiKey management

    # Development tools
    nodejs            # For various plugins
    uv                # Python package manager

    # Scripts
    (pkgs.callPackage ../scripts/getbranch.nix {})
    (pkgs.callPackage ../scripts/gpg-ssh-key.nix {})
  ] ++ scripts.all ++ [
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
    # Fontconfig rule for Google Sans Mono to force monospace spacing
    ".config/fontconfig/conf.d/30-google-sans-mono-mono.conf".source =
      ../assets/fontconfig/30-google-sans-mono-mono.conf;

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
