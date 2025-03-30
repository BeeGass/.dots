# {
#   programs.ssh = {
#     enable = true;
#     addKeysToAgent = "yes";

#     # Use correct identification
#     matchBlocks = {
#       "github" = {
#         user = "git";
#         hostname = "github.com";
#         identitiesOnly = true;
#         # Use a reference to the SSH key from your GPG key
#         # identityFile = "~/.dots/config/home-manager/keychain/id_rsa_yubikey.pub";
#       };
#       "mydesktop" = {
#         user = "beegass";
#         hostname = "130.44.135.194";
#         port = 7569;
#       };
#     };

#     # Additional SSH options
#     extraConfig = ''
#       # Ensure keys are added to the agent
#       AddKeysToAgent yes

#       IdentityAgent none
#       IdentityAgent ''${SSH_AUTH_SOCK}
#     '';
#   };
# }

# config/home-manager/ssh/ssh.nix
# config/home-manager/ssh/ssh.nix
{
  programs.ssh = {
    enable = true;

    matchBlocks = {
      "github" = {
        user = "git";
        hostname = "github.com";
        identitiesOnly = true;
        extraOptions = {
          # Only set the desired IdentityAgent for this host
          IdentityAgent = "\${SSH_AUTH_SOCK}";
        };
      };
      "mydesktop" = {
        user = "beegass";
        hostname = "130.44.135.194";
        port = 7569;
      };
    };

    extraConfig = ''
      Host *
        # ... other Host * options ...
        AddKeysToAgent yes

        # You might still want 'IdentityAgent none' globally
        # IF you want to prevent SSH from automatically trying
        # default agent paths for hosts NOT explicitly configured
        # with a specific IdentityAgent. If you *only* ever use
        # the gpg-agent socket, this might be okay.
        # IdentityAgent none 
    '';
  };
}