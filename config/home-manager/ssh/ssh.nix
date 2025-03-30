{
  programs.ssh = {
    enable = true;
    addKeysToAgent = "yes";

    # Use correct identification
    matchBlocks = {
      "github" = {
        user = "git";
        hostname = "github.com";
        identitiesOnly = true;
        # Use a reference to the SSH key from your GPG key
        # identityFile = "~/.dots/config/home-manager/keychain/id_rsa_yubikey.pub";
      };
      "mydesktop" = {
        user = "beegass";
        hostname = "130.44.135.194";
        port = 7569;
      };
    };

    # Additional SSH options
    extraConfig = ''
      # Ensure keys are added to the agent
      AddKeysToAgent yes

      IdentityAgent none
      IdentityAgent ''${SSH_AUTH_SOCK}
    '';
  };
}
