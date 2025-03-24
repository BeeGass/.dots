#!/usr/bin/env bash
set -eo pipefail  # e: exit on any error, o pipefail: exit if any part of a pipe fails

#######################
## CONFIGURATION SETUP
#######################

# URLs to your dotfiles repo (HTTPS and SSH versions)
DOTS_REPO="https://github.com/BeeGass/.dots.git"
DOTS_SSH_REPO="git@github.com:BeeGass/.dots.git"

# Local directory where your dotfiles repo will live
DOTS_DIR="$HOME/.dots"

# Machine profile to apply (default to 'default' if not provided)
PROFILE="${1:-default}"

# Optional hardcoded username (can be made dynamic if needed later)
USERNAME="beegass"

###############################
## COLOR FUNCTIONS FOR OUTPUT
###############################

# Define color codes
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[0;33m'
RED='\033[0;31m'
NC='\033[0m'  # Reset color

# Logging helpers for consistent colored output
log()    { echo -e "${BLUE}[$(date '+%Y-%m-%d %H:%M:%S')]${NC} $1"; }
error()  { echo -e "${RED}[ERROR]${NC} $1" >&2; exit 1; }
warn()   { echo -e "${YELLOW}[WARNING]${NC} $1"; }
success(){ echo -e "${GREEN}[SUCCESS]${NC} $1"; }

######################################
## VALIDATE ENVIRONMENT: MUST BE NixOS
######################################
if ! grep -q "ID=nixos" /etc/os-release 2>/dev/null; then
  error "This script is intended for NixOS only"
fi

######################################
## ENSURE GIT IS AVAILABLE FOR CLONE
######################################
if ! command -v git &>/dev/null; then
  log "Git not found, installing temporarily with nix-shell..."
  if ! command -v nix-shell &>/dev/null; then
    error "Neither git nor nix-shell are available. Cannot continue."
  fi
  export GIT_CMD="nix-shell -p git --run git"
else
  export GIT_CMD="git"
fi

######################################
## CLONE OR UPDATE DOTFILES REPOSITORY
######################################
if [ -d "$DOTS_DIR" ]; then
  # Repo already cloned
  log "Dots directory already exists at $DOTS_DIR"
  read -p "Update repository? [y/N] " -r
  echo
  if [[ $REPLY =~ ^[Yy]$ ]]; then
    cd "$DOTS_DIR" && $GIT_CMD pull
  fi
else
  # Fresh clone
  log "Cloning dots repository..."
  # Prefer SSH if keys exist
  if [ -f "$HOME/.ssh/id_rsa" ] || [ -f "$HOME/.ssh/id_ed25519" ]; then
    if $GIT_CMD clone "$DOTS_SSH_REPO" "$DOTS_DIR" 2>/dev/null; then
      success "Cloned repository using SSH"
    else
      warn "SSH clone failed, falling back to HTTPS"
      $GIT_CMD clone "$DOTS_REPO" "$DOTS_DIR" || error "Failed to clone repository"
    fi
  else
    # HTTPS fallback
    $GIT_CMD clone "$DOTS_REPO" "$DOTS_DIR" || error "Failed to clone repository"
  fi
fi

######################################
## DETECT BOOT MODE (UEFI vs BIOS)
######################################
if [ -d /sys/firmware/efi/efivars ]; then
  BOOT_MODE="uefi"
  log "Detected UEFI boot mode"
  # Special warning if VM profile is being used in UEFI mode
  if [ "$PROFILE" = "vm" ]; then
    warn "The vm profile is configured for BIOS. You may need to adjust bootloader settings."
  fi
else
  BOOT_MODE="bios"
  log "Detected BIOS boot mode"
  # Warn if BIOS mode but running a non-VM profile
  if [ "$PROFILE" != "vm" ]; then
    warn "You're using a non-VM profile on a BIOS system. You may need to adjust bootloader settings."
  fi
fi

######################################
## VALIDATE HOST PROFILE EXISTS
######################################
HOST_DIR="$DOTS_DIR/hosts/$PROFILE"
if [ ! -d "$HOST_DIR" ]; then
  error "Host directory for '$PROFILE' doesn't exist in the repository"
fi

######################################
## GENERATE HARDWARE CONFIG FOR SYSTEM
######################################
log "Generating hardware configuration..."
sudo mkdir -p /etc/nixos
sudo nixos-generate-config --show-hardware-config > "$HOST_DIR/hardware-configuration.nix"
success "Hardware configuration generated"

######################################
## BACKUP EXISTING NIXOS CONFIG
######################################
if [ -f /etc/nixos/configuration.nix ]; then
  log "Backing up existing configuration..."
  sudo cp /etc/nixos/configuration.nix /etc/nixosconfiguration.nix.backup.$(date +%Y%m%d%H%M%S)
fi

# INSERT THE CLEANUP CODE HERE

######################################
## CLEAN UP EXISTING /etc/nixos/
######################################
log "Cleaning up existing files in /etc/nixos/..."
# Keep only hardware-configuration.nix if it exists and we want to preserve it
if [ -f /etc/nixos/hardware-configuration.nix ] && [ "$1" != "--generate-hardware" ]; then
  sudo mv /etc/nixos/hardware-configuration.nix /etc/nixos/hardware-configuration.nix.preserve
fi

# Remove everything in /etc/nixos/
sudo rm -rf /etc/nixos/*

# Restore hardware config if we preserved it
if [ -f /etc/nixos/hardware-configuration.nix.preserve ]; then
  sudo mv /etc/nixos/hardware-configuration.nix.preserve /etc/nixos/hardware-configuration.nix
fi
success "Cleanup complete"

######################################
## LINK SYSTEM CONFIGURATION FILES
######################################
log "Linking system configurations..."
sudo ln -sf "$HOST_DIR/configuration.nix" /etc/nixos/configuration.nix
sudo ln -sf "$HOST_DIR/hardware-configuration.nix" /etc/nixos/hardware-configuration.nix
success "System configurations linked"

######################################
## DETECT GRUB DEVICE DYNAMICALLY
######################################
GRUB_DEVICE=$(lsblk -ndo pkname $(findmnt -n -o SOURCE /) | head -n1)
if [ -z "$GRUB_DEVICE" ]; then
  warn "Could not detect GRUB device automatically, falling back to /dev/sda"
  GRUB_DEVICE="/dev/sda"
else
  GRUB_DEVICE="/dev/$GRUB_DEVICE"
  log "Detected GRUB device: $GRUB_DEVICE"
fi

######################################
## AUTO ADJUST BOOTLOADER CONFIGURATION
######################################
if [ "$BOOT_MODE" = "uefi" ] && [ "$PROFILE" = "vm" ]; then
  log "Adjusting bootloader configuration for UEFI in VM profile..."
  sudo sed -i 's/boot.loader.grub/# boot.loader.grub/g' "$HOST_DIR/configuration.nix"
  cat << EOF | sudo tee -a "$HOST_DIR/configuration.nix.new"
# Automatically adjusted for UEFI by bootstrap script
boot.loader.systemd-boot.enable = true;
boot.loader.efi.canTouchEfiVariables = true;
boot.loader.efi.efiSysMountPoint = "/boot/efi";
EOF
  sudo mv "$HOST_DIR/configuration.nix.new" "$HOST_DIR/configuration.nix"
elif [ "$BOOT_MODE" = "bios" ] && [ "$PROFILE" != "vm" ]; then
  log "Adjusting bootloader configuration for BIOS..."
  # Disable systemd-boot if BIOS
  sudo sed -i 's/boot.loader.systemd-boot/# boot.loader.systemd-boot/g' "$HOST_DIR/configuration.nix"
  sudo sed -i 's/boot.loader.efi/# boot.loader.efi/g' "$HOST_DIR/configuration.nix"
  cat << EOF | sudo tee -a "$HOST_DIR/configuration.nix.new"
# Automatically adjusted for BIOS by bootstrap script
boot.loader.grub.enable = true;
boot.loader.grub.device = "$GRUB_DEVICE";
boot.loader.grub.useOSProber = true;
EOF
  sudo mv "$HOST_DIR/configuration.nix.new" "$HOST_DIR/configuration.nix"
fi

######################################
## HARDEN SYSTEM CONFIGURATION
######################################
log "Applying security hardening..."
sudo chown -R root:root /etc/nixos
sudo chmod 644 /etc/nixos/configuration.nix
sudo chmod 644 /etc/nixos/hardware-configuration.nix

######################################
## OPTIONAL CONFIG REVIEW BEFORE REBUILD
######################################
if [ -t 0 ]; then  # If script is running in an interactive shell
  read -p "Review configuration before rebuilding? [y/N] " -r
  echo
  if [[ $REPLY =~ ^[Yy]$ ]]; then
    ${EDITOR:-nano} "$HOST_DIR/configuration.nix"
  fi
fi

######################################
## FINAL NIXOS REBUILD WITH FLAKE
######################################
log "Rebuilding NixOS with flake..."
cd "$DOTS_DIR"
sudo nixos-rebuild switch --flake ".#$PROFILE" || error "System rebuild failed"
success "NixOS system rebuild complete"

success "Bootstrap process complete for profile: $PROFILE"
log "You may need to reboot for all changes to take effect"
