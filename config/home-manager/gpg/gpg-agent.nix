{ pkgs, ... }:
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

    pinentry.package = pkgs.pinentry-gtk2; 
    #pinentryPackage = pkgs.pinentry-gtk2;

    # Extra configuration
    extraConfig = ''
      allow-loopback-pinentry
      allow-preset-passphrase
      enable-ssh-support
    '';
  };
}
