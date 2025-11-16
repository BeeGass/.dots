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

{
  programs.ssh = {
    enable = true;

    matchBlocks = {
      # GitHub
      "github github.com" = {
        user = "git";
        hostname = "github.com";
        forwardAgent = false;
      };

      # Tailscale hosts - Raspberry Pis
      "Jacobian Hessian" = {
        hostname = "%h.tailf7d439.ts.net";
        user = "ubuntu";
        port = 40822;
        forwardAgent = false;
      };

      # Tailscale hosts - Workstations
      "Tensor Matrix Vector Manifold" = {
        hostname = "%h.tailf7d439.ts.net";
        user = "beegass";
        port = 40822;
        forwardAgent = false;
      };

      # mcopp with GPG socket forwarding
      "mcopp" = {
        hostname = "mcopp.com";
        user = "beegass";
        port = 12211;
        forwardAgent = true;
        identitiesOnly = false;
        extraOptions = {
          RequestTTY = "yes";
          StreamLocalBindUnlink = "yes";
        };
      };
    };

    extraConfig = ''
      # Include config.d drop-ins (e.g., GPG agent config from setup_gpg_ssh.sh)
      Include ~/.ssh/config.d/*.conf

      # Global defaults
      Host *
        PreferredAuthentications publickey
        PubkeyAuthentication yes
        ForwardAgent no
        ServerAliveInterval 60
        ServerAliveCountMax 3
        IdentitiesOnly no

      # mcopp GPG socket forwarding - Linux client
      Match host mcopp exec "uname -s | grep -q Linux"
        RemoteForward /run/user/1001/gnupg/S.gpg-agent     /run/user/1000/gnupg/S.gpg-agent.extra
        RemoteForward /run/user/1001/gnupg/S.gpg-agent.ssh /run/user/1000/gnupg/S.gpg-agent.ssh

      # mcopp GPG socket forwarding - macOS client
      Match host mcopp exec "uname -s | grep -q Darwin"
        RemoteForward /run/user/1001/gnupg/S.gpg-agent     /Users/beegass/.gnupg/S.gpg-agent.extra
        RemoteForward /run/user/1001/gnupg/S.gpg-agent.ssh /Users/beegass/.gnupg/S.gpg-agent.ssh
    '';
  };
}