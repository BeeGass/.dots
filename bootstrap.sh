#!/usr/bin/env bash
set -eo pipefail

# ... (Keep CONFIGURATION SETUP, COLOR FUNCTIONS, VALIDATE ENVIRONMENT, ENSURE GIT) ...
DOTS_REPO="https://github.com/BeeGass/.dots.git"
DOTS_SSH_REPO="git@github.com:BeeGass/.dots.git"
DOTS_DIR="$HOME/.dots"
PROFILE="${1:-default}"
USERNAME="beegass" # Assuming this is constant for now

GREEN='\033[0;32m'; BLUE='\033[0;34m'; YELLOW='\033[0;33m'; RED='\033[0;31m'; NC='\033[0m';
log()    { echo -e "${BLUE}[$(date '+%Y-%m-%d %H:%M:%S')]${NC} $1"; }
error()  { echo -e "${RED}[ERROR]${NC} $1" >&2; exit 1; }
warn()   { echo -e "${YELLOW}[WARNING]${NC} $1"; }
success(){ echo -e "${GREEN}[SUCCESS]${NC} $1"; }

if ! grep -q "ID=nixos" /etc/os-release 2>/dev/null; then error "This script is intended for NixOS only"; fi
if ! command -v git &>/dev/null; then log "Git not found, using nix-shell..."; export GIT_CMD="nix-shell -p git --run git"; else export GIT_CMD="git"; fi

# --- CLONE OR UPDATE DOTFILES REPOSITORY ---
if [ -d "$DOTS_DIR" ]; then
  log "Dots directory exists: $DOTS_DIR"
  # Optional: Add prompt to update if desired
else
  log "Cloning dots repository..."
  if [ -f "$HOME/.ssh/id_rsa" ] || [ -f "$HOME/.ssh/id_ed25519" ]; then
    if $GIT_CMD clone "$DOTS_SSH_REPO" "$DOTS_DIR" 2>/dev/null; then success "Cloned repository using SSH"; else warn "SSH clone failed, falling back to HTTPS"; $GIT_CMD clone "$DOTS_REPO" "$DOTS_DIR" || error "Failed to clone repository"; fi
  else
    $GIT_CMD clone "$DOTS_REPO" "$DOTS_DIR" || error "Failed to clone repository"
  fi
fi
cd "$DOTS_DIR" || error "Failed to change directory to $DOTS_DIR"

# --- VALIDATE HOST PROFILE ---
HOST_NIXOS_CONFIG_REL_PATH="hosts/$PROFILE/configuration.nix" # Relative path within repo
HOST_NIXOS_CONFIG_ABS_PATH="$DOTS_DIR/$HOST_NIXOS_CONFIG_REL_PATH"
HOST_HW_CONFIG_ABS_PATH="$DOTS_DIR/hosts/$PROFILE/hardware-configuration.nix"

if [ ! -f "$HOST_NIXOS_CONFIG_ABS_PATH" ]; then
  error "Host configuration file not found: $HOST_NIXOS_CONFIG_ABS_PATH"
fi

# --- DETECT BOOT MODE & GRUB DEVICE ---
BOOT_MODE="bios" # Default
GRUB_TARGET_DEVICE=""
if [ -d /sys/firmware/efi/efivars ]; then
  BOOT_MODE="uefi"
  log "Detected UEFI boot mode"
else
  log "Detected BIOS boot mode"
  # Try to detect BIOS boot device
  ROOT_DEVICE_NAME=$(lsblk -ndo pkname "$(findmnt -n -o SOURCE /)" | head -n1)
  if [ -n "$ROOT_DEVICE_NAME" ]; then
    GRUB_TARGET_DEVICE="/dev/$ROOT_DEVICE_NAME"
    log "Detected potential GRUB BIOS device: $GRUB_TARGET_DEVICE"
  else
    warn "Could not detect GRUB BIOS device, will default to /dev/sda in config if GRUB BIOS is chosen."
    GRUB_TARGET_DEVICE="/dev/sda" # Fallback
 fi
fi

# --- GENERATE HARDWARE CONFIG ---
log "Generating hardware configuration..."
sudo mkdir -p /etc/nixos # Ensure target dir exists
# Generate into the correct location WITHIN the checked-out repo
sudo nixos-generate-config --show-hardware-config > "$HOST_HW_CONFIG_ABS_PATH"
success "Hardware configuration generated into repository structure."

# --- BACKUP AND CLEAN /etc/nixos ---
CONFIG_BACKUP_FILE="/etc/nixos/configuration.nix.backup.$(date +%Y%m%d%H%M%S)"
HW_CONFIG_BACKUP_FILE="/etc/nixos/hardware-configuration.nix.backup.$(date +%Y%m%d%H%M%S)"
if [ -f /etc/nixos/configuration.nix ]; then log "Backing up existing configuration to $CONFIG_BACKUP_FILE"; sudo cp /etc/nixos/configuration.nix "$CONFIG_BACKUP_FILE"; fi
if [ -f /etc/nixos/hardware-configuration.nix ]; then log "Backing up existing hardware config to $HW_CONFIG_BACKUP_FILE"; sudo cp /etc/nixos/hardware-configuration.nix "$HW_CONFIG_BACKUP_FILE"; fi
log "Cleaning existing symlinks/files in /etc/nixos/..."
sudo find /etc/nixos/ -maxdepth 1 -type l -delete # Remove symlinks
sudo find /etc/nixos/ -maxdepth 1 -type f \( -name "configuration.nix" -o -name "hardware-configuration.nix" \) -delete # Remove old config files

# --- MODIFY HOST CONFIGURATION BASED ON BOOT MODE ---
log "Adjusting bootloader configuration in $HOST_NIXOS_CONFIG_ABS_PATH for $BOOT_MODE mode..."
CONFIG_TEMP_FILE="${HOST_NIXOS_CONFIG_ABS_PATH}.tmp"
cp "$HOST_NIXOS_CONFIG_ABS_PATH" "$CONFIG_TEMP_FILE" || error "Failed to copy host config for modification"

if [ "$BOOT_MODE" = "uefi" ]; then
  # Prefer systemd-boot for UEFI unless GRUB is explicitly wanted/needed
  # Uncomment systemd-boot section
  sed -i '/# Option 2: systemd-boot/,/# End Bootloader Section/s/# \(boot\.loader\.systemd-boot\)/\1/' "$CONFIG_TEMP_FILE"
  sed -i '/# Option 2: systemd-boot/,/# End Bootloader Section/s/# \(boot\.loader\.efi\.canTouchEfiVariables\)/\1/' "$CONFIG_TEMP_FILE"
  # Ensure GRUB section remains commented
  sed -i '/# Option 1: GRUB/,/# End Bootloader Section/s/^\([ ]*\)\(boot\.loader\.grub\)/#\1\2/' "$CONFIG_TEMP_FILE"
  success "Enabled systemd-boot configuration for UEFI."

  # --- OR --- If you prefer GRUB for UEFI:
  # sed -i '/# Option 1: GRUB/,/# End Bootloader Section/s/# \(boot\.loader\.grub\)/\1/' "$CONFIG_TEMP_FILE"
  # sed -i '/# Option 1: GRUB/,/# End Bootloader Section/s/# \(.*device = \)"nodev";/\1"nodev";/' "$CONFIG_TEMP_FILE" # Set device to nodev
  # sed -i '/# Option 1: GRUB/,/# End Bootloader Section/s/# \(.*efiSupport = true;\)/\1/' "$CONFIG_TEMP_FILE" # Enable EFI support
  # sed -i '/# Option 2: systemd-boot/,/# End Bootloader Section/s/^\([ ]*\)\(boot\.loader\.systemd-boot\)/#\1\2/' "$CONFIG_TEMP_FILE" # Keep systemd-boot commented
  # sed -i '/# Option 2: systemd-boot/,/# End Bootloader Section/s/^\([ ]*\)\(boot\.loader\.efi\.canTouchEfiVariables\)/#\1\2/' "$CONFIG_TEMP_FILE" # Ensure EFI vars is only enabled once
  # success "Enabled GRUB configuration for UEFI."

else # BIOS Mode
  # Uncomment GRUB section
  sed -i '/# Option 1: GRUB/,/# End Bootloader Section/s/# \(boot\.loader\.grub\)/\1/' "$CONFIG_TEMP_FILE"
  # Replace placeholder device with detected or default device
  # Escape slashes in the device path for sed
  GRUB_TARGET_DEVICE_ESCAPED=$(echo "$GRUB_TARGET_DEVICE" | sed 's/\//\\\//g')
  sed -i "/# Option 1: GRUB/,/# End Bootloader Section/s/# \(.*device = \)\"\/dev\/sdX\";/\1\"${GRUB_TARGET_DEVICE_ESCAPED}\";/" "$CONFIG_TEMP_FILE"
  # Ensure systemd-boot section remains commented
  sed -i '/# Option 2: systemd-boot/,/# End Bootloader Section/s/^\([ ]*\)\(boot\.loader\.systemd-boot\)/#\1\2/' "$CONFIG_TEMP_FILE"
  sed -i '/# Option 2: systemd-boot/,/# End Bootloader Section/s/^\([ ]*\)\(boot\.loader\.efi\.canTouchEfiVariables\)/#\1\2/' "$CONFIG_TEMP_FILE"
  success "Enabled GRUB configuration for BIOS with device $GRUB_TARGET_DEVICE."
fi

# Overwrite original config with modified temp file
mv "$CONFIG_TEMP_FILE" "$HOST_NIXOS_CONFIG_ABS_PATH" || error "Failed to update host configuration file"

# --- LINK CONFIGURATION FILES ---
log "Linking system configurations into /etc/nixos/..."
# Use absolute paths from the checked-out repo
sudo ln -sf "$HOST_NIXOS_CONFIG_ABS_PATH" /etc/nixos/configuration.nix
sudo ln -sf "$HOST_HW_CONFIG_ABS_PATH" /etc/nixos/hardware-configuration.nix
success "System configurations linked."

# --- HARDEN (Optional but good) ---
# sudo chown root:root /etc/nixos/configuration.nix /etc/nixos/hardware-configuration.nix
# sudo chmod 644 /etc/nixos/configuration.nix /etc/nixos/hardware-configuration.nix

# --- FINAL NIXOS REBUILD ---
# The config file modified above is now linked in /etc/nixos
# The flake build will use the committed version + local modifications
log "Rebuilding NixOS using flake for profile '$PROFILE'..."
# Make sure we are in the flake directory
cd "$DOTS_DIR" || error "Failed to cd into $DOTS_DIR before rebuild"
# Run the build (will warn about dirty tree because we modified configuration.nix)
sudo nixos-rebuild switch --flake ".#$PROFILE" --show-trace || error "System rebuild failed"
success "NixOS system rebuild complete for profile: $PROFILE"

log "Bootstrap process finished. You may need to reboot."
log "IMPORTANT: Commit the changes made to $HOST_NIXOS_CONFIG_ABS_PATH if you want to keep the bootloader selection."