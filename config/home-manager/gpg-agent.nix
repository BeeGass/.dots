{
  services.gpg-agent = {
    enable = true;
    enableSshSupport = true;
    enableZshIntegration = true;

    # Increased cache times to reduce PIN prompts
    defaultCacheTtl = 3600;        # 1 hour
    maxCacheTtl = 28800;           # 8 hours
    defaultCacheTtlSsh = 3600;     # 1 hour for SSH
    maxCacheTtlSsh = 28800;        # 8 hours for SSH

    # Use tty for CLI or consider "gnome3", "gtk2", "qt" for desktop
    pinentryFlavor = "tty";

    # Additional options for flexibility
    extraConfig = ''
      allow-loopback-pinentry
    '';
  };
}
