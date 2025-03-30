{ pkgs, ... }:

let
  # Your GPG key ID
  keyId = "0xA34200D828A7BB26";

  # Path for the generated SSH public key
  sshKeyPath = "~/.dots/config/home-manager/keychain/id_rsa_yubikey.pub";

  # Utilities we'll need
  gpg = "${pkgs.gnupg}/bin/gpg";
  ssh_add = "${pkgs.openssh}/bin/ssh-add";
  git = "${pkgs.git}/bin/git";

  # The script content
  scriptContent = ''
    #!/usr/bin/env bash
    set -eo pipefail

    # Colors for output
    GREEN='\033[0;32m'
    YELLOW='\033[0;33m'
    RED='\033[0;31m'
    NC='\033[0m'  # No Color

    echo -e "''${YELLOW}Checking GPG-based SSH key setup...''${NC}"

    # Make sure .ssh directory exists
    mkdir -p ~/.ssh
    chmod 700 ~/.ssh

    # Check if the SSH key already exists
    if [ ! -f ${sshKeyPath} ]; then
      echo -e "''${YELLOW}GPG SSH key not found, generating...''${NC}"
      ${gpg} --export-ssh-key ${keyId} > ${sshKeyPath}
      chmod 644 ${sshKeyPath}
      echo -e "''${GREEN}GPG SSH key generated at ${sshKeyPath}''${NC}"
    else
      echo -e "''${GREEN}GPG SSH key already exists at ${sshKeyPath}''${NC}"
    fi

    # Ensure GPG agent is running and has SSH support
    export GPG_TTY=$(tty)
    export SSH_AUTH_SOCK=$(gpgconf --list-dirs agent-ssh-socket)
    gpg-connect-agent updatestartuptty /bye > /dev/null

    # Test if the key is available in the agent
    echo -e "''${YELLOW}Testing SSH key availability...''${NC}"
    SSH_AUTH_SOCK=$(gpgconf --list-dirs agent-ssh-socket) ${ssh_add} -l | grep -q "${keyId}" || {
      echo -e "''${RED}SSH key not found in agent, you might need to:''${NC}"
      echo "1. Ensure your YubiKey is inserted"
      echo "2. Run 'gpg --card-status' to verify YubiKey connection"
      echo "3. Restart the gpg-agent with 'gpgconf --kill gpg-agent'"
      exit 1
    }
    echo -e "''${GREEN}SSH key is available in the agent!''${NC}"

    # Test Git signing capability
    echo -e "''${YELLOW}Testing Git GPG signing capability...''${NC}"
    GIT_TEST_DIR=$(mktemp -d)
    cd $GIT_TEST_DIR
    git init > /dev/null
    git config --local user.name "Test User"
    git config --local user.email "test@example.com"
    git config --local user.signingkey "${keyId}"
    git config --local commit.gpgsign true

    if ${git} commit --allow-empty -m "Test GPG signing" 2>/dev/null; then
      echo -e "''${GREEN}GPG signing test successful!''${NC}"
      echo -e "''${GREEN}Your GPG+SSH setup is working correctly!''${NC}"
    else
      echo -e "''${RED}GPG signing test failed.''${NC}"
      echo "This could be due to your YubiKey not being inserted or PIN not entered."
    fi

    # Clean up
    rm -rf $GIT_TEST_DIR
  '';

in pkgs.writeShellScriptBin "gpg-ssh-setup" scriptContent
