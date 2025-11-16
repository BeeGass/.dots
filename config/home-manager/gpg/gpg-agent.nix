{ pkgs, ... }:
{
  services.gpg-agent = {
    enable = true;
    enableSshSupport = true;
    enableZshIntegration = true;

    # Cache times matching dotfiles configuration
    defaultCacheTtl = 1800;        # 30 minutes
    maxCacheTtl = 7200;            # 2 hours
    defaultCacheTtlSsh = 1800;     # 30 minutes for SSH
    maxCacheTtlSsh = 7200;         # 2 hours for SSH

    pinentryPackage = pkgs.pinentry-gnome3;

    # Extra configuration
    extraConfig = ''
      allow-loopback-pinentry
      allow-preset-passphrase
    '';
  };
}
