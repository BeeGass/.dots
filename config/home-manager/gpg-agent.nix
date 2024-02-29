{
  services.gpg-agent = {
    enable = true;
    enableSshSupport = true;
    enableZshIntegration = true;
    defaultCacheTtl = 60;
    maxCacheTtl = 120;
    pinentryFlavor = "tty";
  };
}
