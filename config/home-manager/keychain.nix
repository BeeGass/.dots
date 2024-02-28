{
  programs.keychain = {
    enable = true;
    enableZshIntegration = true;
    keys = ["id_ed25519"]; #revise keys
    agents = ["gpg" "ssh"];
  };
}
