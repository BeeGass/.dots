{
  programs.keychain = {
    enable = false;
    enableZshIntegration = true;
    keys = ["id_rsa_yubikey.pub"]; # if not here, import from ssh-add -L
    agents = ["gpg" "ssh"];
  };
}
